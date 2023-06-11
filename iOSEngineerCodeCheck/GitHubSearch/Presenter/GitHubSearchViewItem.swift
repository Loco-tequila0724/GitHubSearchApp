//
//  GitHubSearchViewItem.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/04.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import class UIKit.UIImage

/// テーブルビューセルへ表示するデータ構造
struct GitHubSearchViewItem {
    let id: Int
    let fullName: String
    let language: String?
    let stars: String
    let avatarImageView: UIImage?
}

extension GitHubSearchViewItem {
    init(item: Item, image: UIImage?) {
        self.init(
            id: item.id,
            fullName: item.fullName,
            language: "言語 \(item.language ?? "")",
            stars: "☆ \(item.stargazersCount.decimal())",
            avatarImageView: image
        )
    }
}
