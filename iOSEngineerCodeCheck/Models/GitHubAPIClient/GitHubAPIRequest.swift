//
//  APIRequest.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/14.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// MARK: - データをプロトコルに全部書かないといけないのか謎 -
protocol APIRequest {
    var word: String { get }
    var order: StarSortingOrder { get }
    var method: HTTPMethod { get }

    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var gitHubURL: URL? { get }
    func makeURLRequest() throws -> URLRequest
}

struct GitHubAPIRequest: APIRequest {
    var word: String

    var order: StarSortingOrder

    var method: HTTPMethod {
            .get
    }

    var scheme: String {
        "https"
    }

    var host: String {
        "api.github.com"
    }

    var path: String {
        "/search/repositories"
    }

    var queryItems: [URLQueryItem] {
        var queryItem: [URLQueryItem] = [
            URLQueryItem(name: "q", value: word),
            URLQueryItem(name: "per_page", value: "50")
        ]

        queryItem.append(contentsOf: order.queryItems)
        return queryItem
    }

    var gitHubURL: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems
        return components.url
    }

    func makeURLRequest() throws -> URLRequest { // swiftlint:disable:this all
        guard let url = gitHubURL else { throw APIError.notFound }

        var urlRequest = URLRequest(url: url)
        urlRequest.url = url
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}

private extension StarSortingOrder {
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
