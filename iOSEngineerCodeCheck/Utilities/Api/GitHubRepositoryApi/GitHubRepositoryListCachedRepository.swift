//
//  GitHubRepositoryListCachedRepository.swift
//  iOSEngineerCodeCheck
//
//  Created by akio0911 on 2023/06/10.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

class GitHubRepositoryListCachedRepository {
    private var cache: [Order: RepositoryItems] = [:]
    private let apiManager = ApiManager()

    func fetch(word: String, orderType: Order) async -> Result<RepositoryItems, Error> {
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
