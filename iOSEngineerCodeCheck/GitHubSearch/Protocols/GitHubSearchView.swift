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
    func didChangeStarOrder(order: Order)
}
