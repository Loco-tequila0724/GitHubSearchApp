//
//  GitHubSearchViewItem+StarSortingOrder.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/17.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import class UIKit.UIImage
import class UIKit.UIColor

extension GitHubSearchViewItem {
    struct StarSortingOrder {
        var title: String
        var image: UIImage
    }
}

extension GitHubSearchViewItem.StarSortingOrder {
    init(_ order: StarSortingOrder) {
        self.init(
            title: order.title,
            image: .image(color: order.backGroundColor)
        )
    }

    static var none: Self {
        Self.init(.default)
    }
}

private extension StarSortingOrder {
    var title: String {
        switch self {
        case .`default`: return "デフォルト"
        case .desc: return "☆ Star数 ⍋"
        case .asc: return "☆ Star数 ⍒"
        }
    }

    var backGroundColor: UIColor {
        switch self {
        case .`default`: return .lightGray
        case .desc: return UIColor(named: "StarSortColor")!
        case .asc: return UIColor(named: "StarSortColor")!
        }
    }
}
