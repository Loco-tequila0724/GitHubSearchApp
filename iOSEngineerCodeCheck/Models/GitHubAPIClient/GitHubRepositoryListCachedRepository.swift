//
//  GitHubRepositoryListCacheRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/11.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
// ここ読むの辛いかも...

final class GitHubRepositoryListCachedRepository {
    private var items = ItemsRepository()
    private let apiClient = GitHubAPIClient()
}

extension GitHubRepositoryListCachedRepository {
    /// キャッシュがあればキャッシュを返す、なければデータを取得しにいく。
    func fetch(word: String, order: StarSortingOrder) async -> Result<[Item], Error> {
        let cache = items.toDictionary[order]!
        // キャッシュを返す
        guard cache.isEmpty else { return .success(cache) }

        do {
            let request = try GitHubAPIRequest(word: word, order: order).makeURLRequest()
            let data = try await apiClient.validate(request: request)
            let item = try await apiClient.response(httpData: data)
            setRepositoryItem(order: order, items: item.items)
            return .success(item.items)
        } catch {
            return .failure(error)
        }
    }

    func reset() {
        items.allReset()
    }
}

private extension GitHubRepositoryListCachedRepository {
    func setRepositoryItem(order: StarSortingOrder, items: [Item]) {
        switch order {
        case .`default`:
            self.items.`default` = items
        case .asc:
            self.items.asc = items
        case .desc:
            self.items.desc = items
        }
    }
}
