//
//  GitHubSearchInteractor.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit.UIImage // importしなくてもいいようにしたい

final class GitHubSearchInteractor {
    weak var presenter: GitHubSearchOutputUsecase?
    let cachedRepository = GitHubRepositoryListCachedRepository()

    private(set) var items: [Item] = []
    var avatarImages: [Int: UIImage] = [:]
    var word: String = ""
    var orderType: Order = .default
    let imageLoader = ImageLoader()
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

    func search(word: String) {
        reset()
        self.word = word
        fetch(word: word, orderType: orderType)
    }

    func cancelFetching() {
        word = ""
        reset()
        cancel()
    }

    func changeOrder() {
        orderType = orderType.next
        reset()
        fetch(word: word, orderType: orderType)
    }

    func item(at index: Int) -> GitHubSearchViewItem {
        let item = items[index]
        let image = avatarImages[item.id]
        let gitHubSearchViewItem = GitHubSearchViewItem(item: item, image: image?.resize())

        return gitHubSearchViewItem
    }

    /// 画像の取得が完了したら、そのセルだけリロード。.. ここ読むの辛いな〜...
    func fetchAvatarImages(items: [Item]?) async {
        guard let items else { return }

        await withTaskGroup(of: Void.self) { group in
            for item in items {
                group.addTask { [weak self] in
                    guard let strongSelf = self else { return }
                    do {
                        try await Task { @MainActor in
                            // 画像を生成する
                            let image = try await strongSelf.imageLoader.load(url: item.owner.avatarUrl)
                            strongSelf.avatarImages[item.id] = image

                            // 画像元のセルの順番(インデックス番号)を調べリロードする。
                            if let index = items.firstIndex(where: { $0.id == item.id }) {
                                strongSelf.presenter?.didFetchAvatarImage(at: index)
                            }
                        }.value
                    } catch {
                        // エラーだった場合は、ダミーの画像が入る
                        DispatchQueue.main.async { [weak self] in
                            guard let strongSelf = self else { return }
                            strongSelf.avatarImages[item.id] = UIImage(named: "Untitled")!
                            if let index = items.firstIndex(where: { $0.id == item.id }) {
                                strongSelf.presenter?.didFetchAvatarImage(at: index)
                            }
                        }
                    }
                }
            }
        }
    }

}

private extension Order {
    // 他のInteractorでは異なる表示順にしたくなるかもなので、private extensionとした
    var next: Order {
        switch self {
        case .default:
            return .desc
        case .desc:
            return .asc
        case .asc:
            return .default
        }
    }
}
