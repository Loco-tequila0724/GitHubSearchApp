//
//  GitHubApi.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol ApiManagerProtocol {
    func fetch(word: String, order: Order) async throws -> RepositoryItems
}
// MARK: - GitHub API通信で使用する -
final class ApiManager: ApiManagerProtocol {
    private var decoder: JSONDecoder = JSONDecoder()
}

// MARK: - API通信を行なう-
extension ApiManager {
    func fetch(word: String, order: Order) async throws -> RepositoryItems {
        let url = makeURL(word: word, order: order)
        let result = try await convert(request: makeRequest(url: url))

        return result
    }
}

// MARK: - API通信を行なうための部品類 -
private extension ApiManager {
    func makeURL(word: String, order: Order) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/repositories"
        components.queryItems = [
                .init(name: "q", value: word),
                .init(name: "per_page", value: "50")
        ]

        components.queryItems?.append(contentsOf: order.queryItems)

        return components.url
    }

    func makeRequest(url: URL?) throws -> URLRequest { // swiftlint:disable:this all
        guard let url else { throw ApiError.notFound }
        let request = URLRequest(url: url)

        return request
    }

    func httpData(request: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse
        //  短時間で検索されすぎると上限に掛かりこのエラーが返る
        if httpResponse?.statusCode == 403 {
            throw ApiError.forbidden
        }
        // リクエスト成功しなかったらエラーを返す
        guard httpResponse?.statusCode == 200 else {
            throw ApiError.serverError
        }

        return data
    }

    func convert(request: URLRequest) async throws -> RepositoryItems {
        let data = try await httpData(request: request)

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let repositoryItem = try decoder.decode(RepositoryItems.self, from: data)

        // 中身が空ならエラーを返す
        guard !(repositoryItem.items.isEmpty) else {
            throw ApiError.notFound
        }

        return repositoryItem
    }
}

private extension Order {
    var queryItems: [URLQueryItem] {
        switch self {
        case .asc:
            return [
                URLQueryItem(name: "sort", value: "stars"),
                URLQueryItem(name: "order", value: "asc")
            ]
        case .desc:
            return [
                URLQueryItem(name: "sort", value: "stars"),
                URLQueryItem(name: "order", value: "desc")
            ]
        case .`default`:
            return []
        }
    }
}
