//
//  GitHubApi.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

protocol ApiManagerProtocol {
    var decoder: JSONDecoder { get }
    var task: Task<(), Never>? { get }
    func fetch(url: URL?) async -> Result<RepositoryItems, Error>
    func makeURL(word: String, orderType: Order) -> URL?
    func makeRequest(url: URL?) throws -> URLRequest
    func httpData(request: URLRequest) async throws -> Data
    func convert(request: URLRequest) async throws -> RepositoryItems
}

// MARK: - GitHub API通信で使用する -
final class ApiManager {
    private var decoder: JSONDecoder = JSONDecoder()
    private (set) var task: Task<(), Never>?
}

// MARK: - API通信を行なう-
extension ApiManager {
    /// GitHub APIから取得した結果を返す。
    func fetch(word: String, orderType: Order) async -> Result<RepositoryItems, Error> {
        return await withCheckedContinuation { configuration in
            task = Task {
                do {
                    let url = makeURL(word: word, orderType: orderType)
                    let repositoryItem = try await convert(request: makeRequest(url: url))
                    configuration.resume(returning: .success(repositoryItem))
                } catch let error {
                    /// タスクがキャンセルたら、キャンセルエラーを返す。
                    guard !Task.isCancelled else {
                        configuration.resume(returning: .failure(ApiError.cancel))
                        return
                    }

                    /// 独自に定義したエラーを返す
                    if let apiError = error as? ApiError {
                        configuration.resume(returning: .failure(apiError))
                    } else {
                        /// 標準のURLSessionのエラーを返す
                        configuration.resume(returning: .failure(error))
                    }
                }
            }
        }
    }
}

// MARK: - API通信を行なうための部品類 -
extension ApiManager {
    func makeURL(word: String, orderType: Order) -> URL? {
        switch orderType {
        case .`default`:
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.github.com"
            components.path = "/search/repositories"
            components.queryItems = [
                    .init(name: "q", value: word),
                    .init(name: "per_page", value: "50")
            ]
            return components.url

        case .desc:
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.github.com"
            components.path = "/search/repositories"
            components.queryItems = [
                    .init(name: "q", value: word),
                    .init(name: "sort", value: "stars"),
                    .init(name: "order", value: "desc"),
                    .init(name: "per_page", value: "50")
            ]
            return components.url

        case .asc:
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.github.com"
            components.path = "/search/repositories"
            components.queryItems = [
                    .init(name: "q", value: word),
                    .init(name: "sort", value: "stars"),
                    .init(name: "order", value: "asc"),
                    .init(name: "per_page", value: "50")
            ]
            return components.url
        }
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

        // リポジトリデータが空ならエラーを返す
        guard !(repositoryItem.items.isEmpty) else {
            throw ApiError.notFound
        }

        return repositoryItem
    }
}
