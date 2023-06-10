//
//  GitHubRepositoryListCacheRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/11.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

final class GitHubRepositoryListCachedRepository {
    private var cache: [Order: RepositoryItem] = [:]
    private let apiManager = ApiManager()
}

extension GitHubRepositoryListCachedRepository {
    func fetch(word: String, orderType: Order) async -> Result<RepositoryItem, Error> {
        // キャッシュがあれば、RepositoryItemを返す。なければ取得しにいく
        if let cachedItems = cache[orderType] {
            return .success(cachedItems)
        } else {
            return await apiManager.fetch(word: word, orderType: orderType)
        }
    }

    func cancel() {
        apiManager.task?.cancel()
    }
}
