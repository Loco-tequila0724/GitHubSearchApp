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
    var interactor: GitHubSearchInputUsecase { get }
    var router: GitHubSearchWireFrame { get }
    var orderRepository: OrderRepository! { get set }

    func viewDidLoad()
    /// サーチボタンのタップ通知
    func searchButtonDidPush(orderRepository: OrderRepository)
    /// 検索テキストの変更を通知
    func searchTextDidChange()
    /// セルタップを通知
    func didSelectRow(item: Item)
    /// お気に入り順のボタンタップを通知
    func starOderButtonDidPush()
}
