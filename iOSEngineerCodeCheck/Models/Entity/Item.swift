//
//  Item.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/15.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// MARK: - GitHub リポジトリデータ構造 -
struct Item: Decodable {
    let id: ItemID
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let owner: Owner
}
