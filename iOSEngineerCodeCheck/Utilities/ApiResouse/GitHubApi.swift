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

// MARK: - 他ファイルから使用する類 -
extension ApiManager {
    /// GitHub APIから取得した結果を返す。
    func fetch(word: String, completion: @escaping(Result<GitHubRepositories, ApiError>) -> Void) {
        task = Task {
            do {
                let request = try urlRequest(word: word)

                async let defaultRepository = convert(request: request.default)
                async let descRepository = convert(request: request.desc)
                async let ascRepository = convert(request: request.asc)

                let repository = GitHubRepositories(
                    default: try await defaultRepository,
                    desc: try await descRepository,
                    asc: try await ascRepository)

                completion(.success(repository)) 
            } catch let apiError {
                completion(.failure(apiError as? ApiError ?? .unknown))
            }
        }
    }
}

// MARK: - API通信を行なうための部品類 -
private extension ApiManager {
    /// リクエスト生成。URLがない場合、NotFoundエラーを返す。
    func urlRequest(word: String) throws -> (`default`: URLRequest, desc: URLRequest, asc: URLRequest) { // swiftlint:disable:this all

        guard
            let defaultURL: URL = DefaultRepository(word: word).url,
            let descURL: URL = DescRepository(word: word).url,
            let ascURL: URL = AscRepository(word: word).url
            else {
            throw ApiError.notFound
        }

        let defaultRequest = URLRequest(url: defaultURL)
        let descRequest = URLRequest(url: descURL)
        let ascRequest = URLRequest(url: ascURL)

        return (defaultRequest, descRequest, ascRequest)
    }

    /// API通信。デコード。GitHubデータへ変換。
    func convert(request: URLRequest) async throws -> RepositoryItem {
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

        let gitHubData = try decoder.decode(RepositoryItem.self, from: data)

        // GitHubのItemsの中身が空だったらエラーを返す。
        let isEmpty = (gitHubData.items?.compactMap { $0 }.isEmpty)!
        if isEmpty { throw ApiError.notFound }

        return gitHubData
    }
}
