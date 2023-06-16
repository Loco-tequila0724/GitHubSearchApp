//
//  GitHubSearchView.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/19.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// View
protocol GitHubSearchView: AnyObject {
    var presenter: GitHubSearchPresentation! { get }
    func setUp()
    func startLoading()
    func stopLoading()
    func tableViewReload()
    func configure(item: GitHubSearchViewItem, at index: Int)
    func resetDisplay()
    func appearErrorAlert(message: String)
    func appearNotFound(message: String)
    func didChangeStarOrder(order: StarSortingOrder)
}

// テーブルビュー表示の構成
// func configure(item: GitHubSearchViewItem)
// テーブルビューセルの差し替えに使用する。画像が取得できたら更新
// func configure(row: GitHubSearchViewItem.TableRow, at index: Int)
// ソートボタンに関する構成
// func configure(order: GitHubSearchViewItem.StarSortingOrder)
// エラーアラート
// func showErrorAlert(error: Error)
