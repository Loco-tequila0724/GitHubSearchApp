//
//  GitHubSearchUsecase.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/19.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit.UIImage // importしなくてもいいようにしたい

// Interactor インプット
protocol GitHubSearchInputUsecase: AnyObject {
    var presenter: GitHubSearchOutputUsecase? { get }

    var items: [Item] { get }

    var orderType: Order { get }

    func search(word: String)

    func cancelFetching()

    func changeOrder()

    func item(at index: Int) -> GitHubSearchViewItem
}

// Interactor アウトプット
protocol GitHubSearchOutputUsecase: AnyObject {
    func didFetchAvatarImage(at: Int)

    func didFetchSuccess()
    func didFetchError(error: Error)
}
