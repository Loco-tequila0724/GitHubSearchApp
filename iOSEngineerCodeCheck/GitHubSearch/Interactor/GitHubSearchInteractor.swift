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
    private let imageLoader = ImageLoader()
    private var order: Order = .default
    private var items = ItemsRepository()
    private var word: String = ""
    private var avatarImages: [Int: UIImage] = [:]
    private let cachedRepository = GitHubRepositoryListCachedRepository()
}

extension GitHubSearchInteractor {
    func inject(presenter: GitHubSearchPresenter) {
        self.presenter = presenter
    }

    var itemsCount: Int {
        items.current.count
    }

    var nextOrder: Order {
        order = order.next
        return order
    }

    func currentItem(at index: Int) -> Item {
        items.current[index]
    }

    func viewItem(at index: Int) -> GitHubSearchViewItem {
        let item = items.current[index]
        let image = avatarImages[item.id]
        let viewItem = GitHubSearchViewItem(item: item, image: image?.resize())
        return viewItem
    }

    func search(word: String) {
        items.allReset()
        self.word = word
        fetch(word: word, order: order)
    }

    func cancelFetchingAndResetRepository() {
        items.allReset()
        word = ""
        cancel()
    }

    func didFetchResult(result: Result<RepositoryItems, Error>) {
        switch result {
        case .success(let item):
            Task.detached { [weak self] in
                await self?.fetchAvatarImages(items: item.items)
            }
            setSearchOrderItem(item: item)
            presenter?.didFetchSuccess()
        case .failure(let error):
            presenter?.didFetchError(error: error)
        }
    }

    /// Starソート順のタイプとボタンの見た目を変更する
    func changeRepositoryItem() {
        let isEmptyWord = word.isEmpty

        switch order {
        case .`default`:
            if items.default.isEmpty && !isEmptyWord {
                presenter?.startLoading()
                items.current = []
                fetch(word: word, order: order)
            } else {
                items.current = items.default
            }
        case .desc:
            if items.desc.isEmpty && !isEmptyWord {
                presenter?.startLoading()
                items.current = []
                fetch(word: word, order: order)
            } else {
                items.current = items.desc
            }
        case .asc:
            if items.asc.isEmpty && !isEmptyWord {
                presenter?.startLoading()
                items.current = []
                fetch(word: word, order: order)
            } else {
                items.current = items.asc
            }
        }
    }
}

private extension GitHubSearchInteractor {
    func setSearchOrderItem(item: RepositoryItems) {
        let items = item.items
        switch order {
        case .`default`:
            self.items.current = items
            self.items.`default` = items
        case .desc:
            self.items.current = items
            self.items.desc = items
        case .asc:
            self.items.current = items
            self.items.asc = items
        }
    }

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
            let result = await cachedRepository.fetch(word: word, orderType: order)
            didFetchResult(result: result)
        }
    }

    func cancel() {
        cachedRepository.cancel()
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
