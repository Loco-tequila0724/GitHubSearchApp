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
    typealias ViewItem = GitHubSearchViewItem
    typealias TableRow = GitHubSearchViewItem.TableRow
    typealias Order = GitHubSearchViewItem.StarSortingOrder

    var presenter: GitHubSearchPresentation! { get }
    func configure(item: ViewItem)
    func configure(order: Order)
    func configure(row: TableRow, at index: Int)
    func showErrorAlert(error: Error)

    func setUp()
    func startLoading()
    func stopLoading()
    func tableViewReload()
    func resetDisplay()
    func appearErrorAlert(message: String)
    func appearNotFound(message: String)
    func didChangeStarOrder(order: StarSortingOrder)
}

extension GitHubSearchView {
    func configure(item: ViewItem, order: Order) {
        configure(item: item)
        configure(order: order)
    }
}
