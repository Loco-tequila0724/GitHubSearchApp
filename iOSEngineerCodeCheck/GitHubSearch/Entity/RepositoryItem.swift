//
//  StarOrder.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

///  リポジトリを表示する順序に関する
protocol RepositoryItem {
    var items: [Item?] { get set }
    var text: String { get }
    var color: UIColor { get }
    var word: String { get set }
    var url: URL? { get }
}

/// 順序がデフォルト時の際に使用する
struct DefaultRepository: RepositoryItem {
    var items: [Item?]
    var word: String
    var text: String
    var color: UIColor

    init(word: String = "") {
        self.items = []
        self.word = word
        self.text = "☆ Star数 "
        self.color = .lightGray
    }

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/repositories"
        components.queryItems = [
                .init(name: "q", value: word),
                .init(name: "per_page", value: "50")
        ]
        return components.url
    }
}

/// スター数が多い順の際に使用する
struct DescRepository: RepositoryItem {
    var items: [Item?]
    var word: String
    var text: String
    var color: UIColor

    init(word: String = "") {
        self.items = []
        self.word = word
        self.text = "☆ Star数 ⍋"
        self.color = #colorLiteral(red: 0.1634489, green: 0.1312818527, blue: 0.2882181406, alpha: 1)
    }

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/repositories"
        components.queryItems = [
                .init(name: "q", value: word),
                .init(name: "sort", value: "stars"),
                .init(name: "order", value: "desc"),
                .init(name: "per_page", value: "50")
        ]
        return components.url
    }
}

/// スター数が少ない順の際に使用する
struct AscRepository: RepositoryItem {
    var items: [Item?]
    var word: String
    var text: String
    var color: UIColor

    init(word: String = "") {
        self.items = []
        self.word = word
        self.text = "☆ Star数 ⍒"
        self.color = #colorLiteral(red: 0.1634489, green: 0.1312818527, blue: 0.2882181406, alpha: 1)
    }

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/repositories"
        components.queryItems = [
                .init(name: "q", value: word),
                .init(name: "sort", value: "stars"),
                .init(name: "order", value: "asc"),
                .init(name: "per_page", value: "50")
        ]
        return components.url
    }
}
