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
    private let apiManager = ApiManager()
    private var items = ItemsRepository()
}

extension GitHubRepositoryListCachedRepository {
    /// キャッシュがあればキャッシュを返す、なければデータを取得しにいく。
    func fetch(word: String, order: Order) async -> Result<[Item], Error> {
        let cache = items.toDictionary[order]!
        // キャッシュを返す
        guard cache.isEmpty else { return .success(cache) }

        // キャシュを取得しに行き、成功ならリポジトリへセット。
        let fetchItem = await apiManager.fetch(word: word, orderType: order)
        let result = await convertAndSetItems(result: fetchItem, order: order)
        return result
    }

    func cancel() {
        apiManager.task?.cancel()
    }

    func reset() {
        items.allReset()
    }
}

private extension GitHubRepositoryListCachedRepository {
    func setRepositoryItem(order: Order, items: [Item]) {
        switch order {
        case .`default`:
            self.items.`default` = items
        case .asc:
            self.items.asc = items
        case .desc:
            self.items.desc = items
        }
    }

    func convertAndSetItems(result: Result<RepositoryItems, Error>, order: Order) async -> Result<[Item], Error> {
        switch result {
        case .success(let item):
            setRepositoryItem(order: order, items: item.items)
            return .success(item.items)
        case .failure(let error):
            return .failure(error)
        }
    }
}
