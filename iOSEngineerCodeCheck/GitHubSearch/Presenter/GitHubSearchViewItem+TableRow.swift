//
//  GitHubSearchViewItem+TableRow.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/17.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import class UIKit.UIImage

extension GitHubSearchViewItem {
    struct TableRow {
        let id: ItemID
        let fullName: String
        let language: String?
        let stars: String
        let avatarImageView: UIImage?
    }
}

extension GitHubSearchViewItem.TableRow {
    init(item: Item, image: UIImage?) {
        self.init(
            id: item.id,
            fullName: item.fullName,
            language: "言語 \(item.language ?? "")",
            stars: "☆ \(item.stargazersCount.to1000SeparatedString())",
            avatarImageView: image
        )
    }
}
