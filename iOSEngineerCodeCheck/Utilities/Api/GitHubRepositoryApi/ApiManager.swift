//
//  GitHubApi.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol ApiManagerProtocol {
    func fetch(word: String, orderType: Order) async -> Result<RepositoryItems, Error>
}
// MARK: - GitHub API通信で使用する -
final class ApiManager: ApiManagerProtocol {
    private var decoder: JSONDecoder = JSONDecoder()
}

// MARK: - API通信を行なう-
extension ApiManager {
    /// GitHub APIから取得した結果を返す。
    func fetch(word: String, orderType: Order) async -> Result<RepositoryItems, Error> {
        do {
            let url = makeURL(word: word, orderType: orderType)
            let result = try await convert(request: makeRequest(url: url))
            return .success(result)
        } catch {
            if let apiError = error as? ApiError {
                return .failure(apiError)
            } else {
                return .failure(error)
            }
        }
    }
}

// MARK: - API通信を行なうための部品類 -
private extension ApiManager {
    func makeURL(word: String, orderType: Order) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/repositories"
        components.queryItems = [
                .init(name: "q", value: word),
                .init(name: "per_page", value: "50")
        ]

        if orderType == .asc || orderType == .desc {
            components.queryItems?.append(contentsOf: [
                    .init(name: "sort", value: "stars"),
                    .init(name: "order", value: orderType.description)
                ])
        }

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
