//
//  GitHubSearchUsecase.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/19.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// Interactor インプット
protocol GitHubSearchInputUsecase: AnyObject {
    var presenter: GitHubSearchOutputUsecase? { get }
    var itemsCount: Int { get }
    var nextOrder: Order { get }
    var task: Task<(), Never>? { get }
    func currentItem(at index: Int) -> Item
    func viewItem(at index: Int) -> GitHubSearchViewItem
    func cancelFetchingAndResetRepository()
    func search(word: String)
    func fetch(word: String, order: Order)
    func changeRepositoryItem()
}

// Interactor アウトプット
protocol GitHubSearchOutputUsecase: AnyObject {
    func didFetchSuccess()
    func didFetchError(error: Error)
    func startLoading()
    func viewReloadRow(at index: Int)
}
