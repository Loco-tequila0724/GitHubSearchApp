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
            loading: .stop,
            emptyDescription: .hidden,
            table: .empty
        )
    }

    static var empty: Self {
            .init(
            loading: .stop,
            emptyDescription: .visible,
            table: .empty
        )
    }

    static var loading: Self {
            .init(
            loading: .start,
            emptyDescription: .visible,
            table: .empty
        )
    }
}

extension GitHubSearchViewItem.Table {
    static var empty: Self {
            .init(items: [])
    }
}

extension GitHubSearchViewItem.Loading {
    static var start: Self {
            .init(isAnimating: true)
    }

    static var stop: Self {
            .init(isAnimating: false)
    }
}

extension GitHubSearchViewItem.EmptyDescription {
    static var visible: Self {
            .init(isHidden: false)
    }

    static var hidden: Self {
            .init(isHidden: true)
    }
}
