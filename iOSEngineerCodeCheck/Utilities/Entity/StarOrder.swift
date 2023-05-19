//
//  StarOrder.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

// MARK: - Star数ボタンに関する -
enum StarOrder {
    case desc
    case asc
    case `default`

    var text: String {
        switch self {
        case .desc: return "☆ Star数 ⍋"
        case .asc: return "☆ Star数 ⍒"
        case .`default`: return "☆ Star数 "
        }
    }

    var color: UIColor {
        switch self {
        case .desc: return #colorLiteral(red: 0.1634489, green: 0.1312818527, blue: 0.2882181406, alpha: 1)
        case .asc: return #colorLiteral(red: 0.1634489, green: 0.1312818527, blue: 0.2882181406, alpha: 1)
        case .`default`: return .lightGray
        }
    }
}

protocol StarOrderTest {
    var items: [Item?] { get }
    var text: String { get }
    var color: UIColor { get }
}

struct StarDesc: StarOrderTest {
    var items: [Item?]
    var text: String
    var color: UIColor

    init() {
        self.items = []
        self.text = "☆ Star数 ⍋"
        self.color = #colorLiteral(red: 0.1634489, green: 0.1312818527, blue: 0.2882181406, alpha: 1)
    }
}

struct StarAsc: StarOrderTest {
    var items: [Item?]
    var text: String
    var color: UIColor

    init() {
        self.items = []
        self.text = "☆ Star数 ⍒"
        self.color = #colorLiteral(red: 0.1634489, green: 0.1312818527, blue: 0.2882181406, alpha: 1)
    }
}

struct StarDefault: StarOrderTest {
    var items: [Item?]
    var text: String
    var color: UIColor

    init() {
        self.items = []
        self.text = "☆ Star数 "
        self.color = .lightGray
    }
}
