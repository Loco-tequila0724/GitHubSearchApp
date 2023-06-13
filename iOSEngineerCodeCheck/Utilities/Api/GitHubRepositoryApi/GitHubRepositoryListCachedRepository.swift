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

        do {
            // キャシュを取得しに行き、成功ならリポジトリへセット。
            let item = try await apiManager.fetch(word: word, order: order)
            setRepositoryItem(order: order, items: item.items)
            return .success(item.items)
        } catch {
            if let apiError = error as? ApiError {
                return .failure(apiError)
            } else {
                return .failure(error)
            }
        }
    }

    func reset() {
        items.allReset()
    }
}

private extension GitHubRepositoryListCachedRepository {
    ///
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
}
