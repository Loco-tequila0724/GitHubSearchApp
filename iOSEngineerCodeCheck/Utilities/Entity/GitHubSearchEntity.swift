//
//  GitHubSearchEntity.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

struct GitHubSearchEntity: Decodable {
    var items: [Item]?
}
// MARK: - GitHub リポジトリデータ構造 -
struct Item: Decodable {
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let owner: Owner

    enum CodingKeys: String, CodingKey {
        case language = "language"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case fullName = "full_name"
        case owner
    }
}

struct Owner: Decodable {
    let avatarUrl: URL

    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
