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
    /// API通信を行い、GitHubのデータをデータベースから取得
    func fetch(word: String, orderType: Order)

    func cancel()
}

// Interactor アウトプット
protocol GitHubSearchOutputUsecase: AnyObject {
    /// 取得したGitHubデータの結果をViewへ通知
    func didFetchResult(result: Result<RepositoryItems, Error>)
}
