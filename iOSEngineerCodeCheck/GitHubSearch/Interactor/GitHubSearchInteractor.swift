//
//  GitHubSearchInteractor.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

final class GitHubSearchInteractor {
    weak var presenter: GitHubSearchOutputUsecase?
    let apiManager = ApiManager()
}

extension GitHubSearchInteractor: GitHubSearchInputUsecase {
    /// データベースから GitHubデータを取得。
    func fetch(text: String) {
        apiManager.fetch(text: text) { [weak self] result in
            self?.presenter?.didFetchResult(result: result)
        }
    }
}
