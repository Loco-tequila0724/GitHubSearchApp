//
//  GitHubSearchInteractor.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import class UIKit.UIImage

final class GitHubSearchInteractor {
    weak var presenter: GitHubSearchOutputUsecase?
    private let cachedRepository = GitHubRepositoryListCachedRepository()
    private let imageLoader = ImageLoader()
    private var items: [Item] = []
    private var word: String = ""
    private var order: StarSortingOrder = .default
    private var avatarImages: [ItemID: UIImage] = [:]
    private(set) var task: Task<(), Never>?
    private(set) var taskOfImage: Task<(), Never>?
}

extension GitHubSearchInteractor {
    var itemsCount: Int {
        items.count
    }

    var nextOrder: StarSortingOrder {
        order = order.next
        return order
    }

    func inject(presenter: GitHubSearchPresenter) {
        self.presenter = presenter
    }

    func currentItem(at index: Int) -> Item {
        items[index]
    }

    func viewItem(at index: Int) -> GitHubSearchViewItem {
        let item = items[index]
        let image = avatarImages[item.id]
        let viewItem = GitHubSearchViewItem(item: item, image: image?.compress())
        return viewItem
    }

    func search(word: String) {
        self.word = word
        items = []
        cachedRepository.reset()
        fetch(word: word, order: order)
    }

    func cancelFetchingAndResetRepository() {
        word = ""
        items = []
        task?.cancel()
        cachedRepository.reset()
    }

    func changeRepositoryItem() {
        if !word.isEmpty {
            items = []
            presenter?.startLoading()
            fetch(word: word, order: order)
        }
    }
}

extension GitHubSearchInteractor: GitHubSearchInputUsecase {
    /// データベースから GitHubデータを取得。
    func fetch(word: String, order: StarSortingOrder) {
        task = Task {
            let result = await cachedRepository.fetch(word: word, order: order)
            switch result {
            case .success(let items):
                self.items = items
                presenter?.didFetchSuccess()
            case .failure(let error):
                presenter?.didFetchError(error: error)
            }
        }
    }

    /// 画像の取得が完了したら、そのセルだけ更新。
    func fetchAvatarImages(at index: Int) {
        Task {
            let item = self.items[index]
            Task { @MainActor in
                let image = (try? await self.imageLoader.load(url: item.owner.avatarUrl)) ?? UIImage(named: "Untitled")!
                self.avatarImages[item.id] = image

                guard let index = self.items.firstIndex(where: { $0.id == item.id }) else {
                    return
                }

                let viewItem = GitHubSearchViewItem(item: item, image: image)
                self.presenter?.didFetchAvatarImage(item: viewItem, at: index)
            }
        }
    }
}

private extension StarSortingOrder {
    var next: StarSortingOrder {
        switch self {
        case .`default`: return .desc
        case .asc: return .`default`
        case .desc: return .asc
        }
    }
}
