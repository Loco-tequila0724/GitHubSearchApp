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
    func fetch(word: String) async -> Result<GitHubRepositories, Error> {
        return await withCheckedContinuation { configuration in
            task = Task {
                do {
                    let repositories = try await setRepositories(word: word)
                    configuration.resume(returning: .success(repositories))
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
    /// リクエスト生成
    func makeRequest(word: String) throws -> (`default`: URLRequest, desc: URLRequest, asc: URLRequest) { // swiftlint:disable:this all

        guard
            let defaultURL: URL = DefaultSearchItem(word: word).url,
            let descURL: URL = DescSearchItem(word: word).url,
            let ascURL: URL = AscSearchItem(word: word).url
            else {
            throw ApiError.notFound
        }

        let defaultRequest = URLRequest(url: defaultURL)
        let descRequest = URLRequest(url: descURL)
        let ascRequest = URLRequest(url: ascURL)

        return (defaultRequest, descRequest, ascRequest)
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

    /// API通信を行い取得データをデコード
    func convert(request: URLRequest) async throws -> RepositoryItem {
        let data = try await httpData(request: request)

        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let gitHubData = try decoder.decode(RepositoryItem.self, from: data)

        // リポジトリデータがnilまたは、中身が空ならエラーを返す
        guard let items = gitHubData.items, !(items.isEmpty) else {
            throw ApiError.notFound
        }
        return gitHubData
    }
}

private extension ApiManager {
    /// リポジトリデータ(デフォルト, 降順, 昇順)をセット
    func setRepositories(word: String) async throws -> GitHubRepositories {
        let request = try self.makeRequest(word: word)

        async let defaultRepository = self.convert(request: request.default)
        async let descRepository = self.convert(request: request.desc)
        async let ascRepository = self.convert(request: request.asc)

        let repositories = GitHubRepositories(
            default: try await defaultRepository,
            desc: try await descRepository,
            asc: try await ascRepository)

        return repositories
    }
}
