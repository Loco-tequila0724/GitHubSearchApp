//
//  GitHubApi.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// MARK: - GitHub API通信で使用する -
class ApiManager {
    var decoder: JSONDecoder = JSONDecoder()
    var result: (Result<GitHubSearchEntity, ApiError>)?
    var task: Task<(), Never>?
}

// MARK: - 他ファイルから使用するる類 -
extension ApiManager {
    /// GitHubデータベースから取得した結果を返す。
    func fetch(text: String, completion: @escaping(Result<GitHubSearchEntity, ApiError>) -> Void) {
        task = Task {
            do {
                let request = try self.urlRequest(text: text)
                let gitHubData = try await convert(request: request)
                result = .success(gitHubData)
                completion(result!)
            } catch let apiError {
                // タスクをキャンセルされたらリターン
                if Task.isCancelled { return }
                result = .failure(apiError as? ApiError ?? .unknown)
                completion(result!)
            }
        }
    }
}

// MARK: - API通信を行なうための部品類 -
private extension ApiManager {
    /// リクエスト生成。URLがない場合、NotFoundエラーを返す。
    func urlRequest(text: String) throws -> URLRequest {
        guard let url: URL = URL(string: "https://api.github.com/search/repositories?q=\(text)&per_page=60") else {
            throw ApiError.notFound
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }

    /// API通信。デコード。GitHubデータへ変換。
    func convert(request: URLRequest) async throws -> GitHubSearchEntity {
        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse
        ///  短時間で検索されすぎるとこのエラーが返る
        if httpResponse?.statusCode == 403 {
            throw ApiError.forbidden
        }
        // リクエスト成功しなかったらエラーを返す
        guard httpResponse?.statusCode == 200 else {
            throw ApiError.serverError
        }

        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let gitHubData = try decoder.decode(GitHubSearchEntity.self, from: data)

        // GitHubのItemsの中身が空だったらエラーを返す。
        let isEmpty = (gitHubData.items?.compactMap { $0 }.isEmpty)!
        if isEmpty { throw ApiError.notFound }

        return gitHubData
    }
}
