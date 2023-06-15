//
//  APIClient.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/14.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// MARK: - ここもstructで良いのか？ classとstructの使い分けの理解が危うい-
struct GitHubAPIClient {
    typealias Response = RepositoryItems

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        return session
    }
}

extension GitHubAPIClient {
    func validate(request: URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: request)
        try checkResponseStatus(response: response)
        return data
    }

    func checkResponseStatus(response: URLResponse) throws {
        let httpResponse = response as? HTTPURLResponse
        //  短時間で検索されすぎると上限に掛かりこのエラーが返る
        if httpResponse?.statusCode == 403 {
            throw APIError.forbidden
        }
        // リクエスト成功しなかったらエラーを返す
        guard httpResponse?.statusCode == 200 else {
            throw APIError.serverError
        }
    }

    func response(httpData: Data) async throws -> Response {
        let response = try decoder.decode(Response.self, from: httpData)
        // 中身が空ならエラーを返す
        guard !(response.items.isEmpty) else {
            throw APIError.notFound
        }

        return response
    }
}
