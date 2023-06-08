//
//  StarOrder.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit.UIColor

protocol OrderSearchItem {
    var items: [Item] { get set }
    var text: String { get }
    var color: UIColor { get }
}

/// 順序がデフォルト時の際に使用する
struct DefaultOrderSearchItem: OrderSearchItem {
    var items: [Item]
    var text: String
    var color: UIColor

    init() {
        self.items = []
        self.text = "☆ Star数 "
        self.color = .lightGray
    }
}

/// スター数が多い順の際に使用する
struct DescOrderSearchItem: OrderSearchItem {
    var items: [Item]
    var text: String
    var color: UIColor

    init() {
        self.items = []
        self.text = "☆ Star数 ⍋"
        self.color = #colorLiteral(red: 0.1634489, green: 0.1312818527, blue: 0.2882181406, alpha: 1)
    }
}

/// スター数が少ない順の際に使用する
struct AscOrderSearchItem: OrderSearchItem {
    var items: [Item]
    var text: String
    var color: UIColor

    init() {
        self.items = []
        self.text = "☆ Star数 ⍒"
        self.color = #colorLiteral(red: 0.1634489, green: 0.1312818527, blue: 0.2882181406, alpha: 1)
    }
}
