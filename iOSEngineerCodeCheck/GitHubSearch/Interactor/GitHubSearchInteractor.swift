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
    let cachedRepository = GitHubRepositoryListCachedRepository()

    private(set) var items: [Item] = []
}

extension GitHubSearchInteractor: GitHubSearchInputUsecase {
    /// データベースから GitHubデータを取得。
    func fetch(word: String, orderType: Order) {
        Task {
            let result = await cachedRepository.fetch(word: word, orderType: orderType)
            presenter?.didFetchResult(result: result)
        }
    }

    func cancel() {
        cachedRepository.cancel()
    }

    /// 保管しているリポジトリのデータをリセット
    func reset() {
        items = []
    }

    ///  APIから取得したデータを各リポジトリへセット
    func setSearchOrderItem(item: RepositoryItems) {
        self.items = item.items
    }
}
