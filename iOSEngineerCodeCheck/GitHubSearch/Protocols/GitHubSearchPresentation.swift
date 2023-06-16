//
//  GitHubSearchPresentation.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/19.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// Presenter
protocol GitHubSearchPresentation: AnyObject {
    var view: GitHubSearchView? { get }

    var numberOfRow: Int { get }

    func item(at index: Int) -> GitHubSearchViewItem

    func viewDidLoad()

    func willDisplayRow(at index: Int)
    /// サーチボタンのタップ通知
    func searchButtonDidPush(word: String)
    /// 検索テキストの変更を通知
    func searchTextDidChange()
    /// セルタップを通知
    func didSelectRow(at index: Int)
    /// お気に入り順のボタンタップを通知
    func starOderButtonDidPush()
}
