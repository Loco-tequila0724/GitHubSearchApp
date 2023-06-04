//
//  GitHubSearchViewItem.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/04.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit.UIImage

struct GitHubSearchViewItem {
    let id: Int
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let avatarImageView: UIImage
}

extension GitHubSearchViewItem {
    init(item: Item, image: UIImage) {
        self.init(
            id: item.id,
            fullName: item.fullName,
            language: item.language,
            stargazersCount: item.stargazersCount,
            avatarImageView: image
        )
    }
}
