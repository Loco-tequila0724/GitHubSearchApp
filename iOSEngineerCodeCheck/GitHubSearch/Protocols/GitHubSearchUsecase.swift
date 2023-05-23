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
    /// gitHubApiにアクセスする
    var apiManager: ApiManager { get }
    /// API通信を行い、GitHubのデータをデータベースから取得
    func fetch(word: String)
}

// Interactor アウトプット
protocol GitHubSearchOutputUsecase: AnyObject {
    /// 取得したGitHubデータの結果をPresenterへ通知
    func didFetchResult(result: Result<GitHubRepositories, Error>)
}
