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
    private var order: Order = .default
    private var avatarImages: [Int: UIImage] = [:]
}

extension GitHubSearchInteractor {
    var itemsCount: Int {
        items.count
    }

    var nextOrder: Order {
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
        let viewItem = GitHubSearchViewItem(item: item, image: image?.resize())
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
        cachedRepository.reset()
        cachedRepository.cancel()
    }

    func changeRepositoryItem() {
        if !word.isEmpty {
            items = []
            presenter?.startLoading()
            fetch(word: word, order: order)
        }
    }
}

private extension GitHubSearchInteractor {
    /// 画像の取得が完了したら、そのセルだけリロード。.. ここ読むの辛いな〜...
    func fetchAvatarImages(items: [Item]?) async {
        guard let items else { return }

        await withTaskGroup(of: Void.self) { group in
            for item in items {
                group.addTask { [weak self] in
                    guard let self else { return }
                    do {
                        try await Task { @MainActor in
                            // 画像を生成する
                            let image = try await self.imageLoader.load(url: item.owner.avatarUrl)
                            self.avatarImages[item.id] = image

                            // 画像元のセルの順番(インデックス番号)を調べリロードする。
                            if let index = items.firstIndex(where: { $0.id == item.id }) {
                                self.presenter?.viewReloadRow(at: index)
                            }
                        }.value
                    } catch {
                        // エラーだった場合は、ダミーの画像が入る
                        DispatchQueue.main.async {
                            self.avatarImages[item.id] = UIImage(named: "Untitled")!
                            if let index = items.firstIndex(where: { $0.id == item.id }) {
                                self.presenter?.viewReloadRow(at: index)
                            }
                        }
                    }
                }
            }
        }
    }
}

extension GitHubSearchInteractor: GitHubSearchInputUsecase {
    /// データベースから GitHubデータを取得。
    func fetch(word: String, order: Order) {
        Task {
            let result = await cachedRepository.fetch(word: word, order: order)
            switch result {
            case .success(let items):
                Task.detached { [weak self] in
                    await self?.fetchAvatarImages(items: items)
                }
                self.items = items
                presenter?.didFetchSuccess()
            case .failure(let error):
                presenter?.didFetchError(error: error)
            }
        }
    }
}

private extension Order {
    var next: Order {
        switch self {
        case .`default`: return .desc
        case .desc: return .asc
        case .asc: return .`default`
        }
    }
}
