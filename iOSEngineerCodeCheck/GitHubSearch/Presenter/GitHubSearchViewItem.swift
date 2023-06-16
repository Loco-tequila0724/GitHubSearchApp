//
//  GitHubSearchViewItem.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/04.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import class UIKit.UIImage

struct GitHubSearchViewItem {
    var loading: Loading
    var emptyDescription: EmptyDescription
    var table: Table
}

extension GitHubSearchViewItem {
    struct Loading {
        var isAnimating: Bool
    }

    struct EmptyDescription {
        var isHidden: Bool
    }

    struct Table {
        var items: [TableRow]?
    }
}

extension GitHubSearchViewItem {
    static var initial: Self {
            .init(
            loading: .init(isAnimating: false),
            emptyDescription: .init(isHidden: true),
            table: .empty
        )
    }

    static var empty: Self {
            .init(
            loading: .init(isAnimating: false),
            emptyDescription: .init(isHidden: false),
            table: .empty
        )
    }

    static var loading: Self {
            .init(
            loading: .init(isAnimating: true),
            emptyDescription: .init(isHidden: false),
            table: .empty
        )
    }
}

extension GitHubSearchViewItem.Table {
    static var empty: Self {
            .init(items: [])
    }
}
