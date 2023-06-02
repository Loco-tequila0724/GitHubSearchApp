//
//  GitHubApi.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// MARK: - GitHub API通信で使用する -
final class ApiManager {
    private var decoder: JSONDecoder = JSONDecoder()
    private (set) var task: Task<(), Never>?
}

// MARK: - API通信を行なう-
extension ApiManager {
    /// GitHub APIから取得した結果を返す。
    func fetch(url: URL?) async -> Result<RepositoryItem, Error> {
        return await withCheckedContinuation { configuration in
            task = Task {
                do {
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
private extension ApiManager {
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

    func convert(request: URLRequest) async throws -> RepositoryItem {
        let data = try await httpData(request: request)

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let repositoryItem = try decoder.decode(RepositoryItem.self, from: data)

        // リポジトリデータがnilまたは、中身が空ならエラーを返す
        guard let items = repositoryItem.items, !(items.isEmpty) else {
            throw ApiError.notFound
        }

        return repositoryItem
    }
}
