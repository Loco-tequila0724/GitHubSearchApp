//
//  GitHubSearchEntity.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

struct RepositoryItems: Decodable {
    var items: [Item]
}
// MARK: - GitHub リポジトリデータ構造 -
struct Item: Decodable {
    let id: Int
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let owner: Owner
}

struct Owner: Decodable {
    let avatarUrl: URL
    let htmlUrl: String
}
