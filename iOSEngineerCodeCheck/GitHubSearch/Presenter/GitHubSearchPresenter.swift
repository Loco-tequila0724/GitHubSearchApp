//
//  GitHubSearchPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import UIKit.UIImage

final class GitHubSearchPresenter {
    weak var view: GitHubSearchView?
    private var interactor: GitHubSearchInputUsecase
    private var router: GitHubSearchWireFrame
    private var order = OrderItemManager()
    private let imageLoader = ImageLoader()
    private var orderType: Order = .default
    private var word: String = ""
    private var avatarImages: [Int: UIImage] = [:]

    init(
        view: GitHubSearchView? = nil,
        interactor: GitHubSearchInputUsecase,
        router: GitHubSearchWireFrame) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}
// MARK: - GitHubSearchPresentationプロトコルに関する -
extension GitHubSearchPresenter: GitHubSearchPresentation {
    var numberOfRow: Int {
        return order.current.items.count
    }

    func viewDidLoad() {
        view?.configure()
    }

    /// 検索ボタンのタップを検知。 GitHubデータのリセット。ローディングの開始。GitHubデータの取得を通知。
    func searchButtonDidPush(word: String) {
        reset()
        self.word = word
        view?.resetDisplay()
        view?.startLoading()
        interactor.fetch(word: word, orderType: orderType)
    }

    /// テキスト変更を検知。GitHubデータと画面の状態をリセット。タスクのキャンセル
    func searchTextDidChange() {
        word = ""
        reset()
        view?.resetDisplay()
        interactor.apiManager.task?.cancel()
    }

    /// セルタップの検知。DetailVCへ画面遷移通知。
    func didSelectRow(at index: Int) {
        let item = order.current.items[index]
        router.showGitHubDetailViewController(item: item)
    }

    /// スター数順の変更ボタンのタップを検知。(スター数で降順・昇順を切り替え)
    func starOderButtonDidPush() {
        changeStarOrder()
        fetchOrSetSearchOrderItem()
        view?.tableViewReload()
    }

    func item(at index: Int) -> GitHubSearchViewItem {
        let item = order.current.items[index]
        let image = avatarImages[item.id]
        let gitHubSearchViewItem = GitHubSearchViewItem(item: item, image: image?.compress())

        return gitHubSearchViewItem
    }
}

// MARK: - GitHubSearchOutputUsecase プロトコルに関する -
extension GitHubSearchPresenter: GitHubSearchOutputUsecase {
    /// GitHubリポジトリデータを各リポジトリ (デフォルト, 降順, 昇順) に保管しテーブルビューへ表示。
    func didFetchResult(result: Result<RepositoryItem, Error>) {
        view?.stopLoading()
        switch result {
        case .success(let item):
            Task.detached { [weak self] in
                await self?.fetchAvatarImages(items: item.items)
            }
            setSearchOrderItem(item: item)
            view?.tableViewReload()
        case .failure(let error):
            setAppearError(error: error)
        }
    }
}

private extension GitHubSearchPresenter {
    /// 画像の取得が完了したら、そのセルだけリロード。.. ここ読むの辛いな〜...
    func fetchAvatarImages(items: [Item]?) async {
        guard let items else { return }

        await withTaskGroup(of: Void.self) { group in
            for item in items {
                group.addTask {
                    do {
                        try await Task { @MainActor in
                            // 画像を生成する
                            let image = try await self.imageLoader.load(url: item.owner.avatarUrl)
                            self.avatarImages[item.id] = image

                            // 画像元のセルの順番(インデックス番号)を調べリロードする。
                            if let index = self.order.current.items.firstIndex(where: { $0.id == item.id }) {
                                self.view?.reloadRow(at: index)
                            }
                        }.value
                    } catch {
                        // エラーだった場合は、ダミーの画像が入る
                        DispatchQueue.main.async {
                            self.avatarImages[item.id] = UIImage(named: "Untitled")!
                            if let index = self.order.current.items.firstIndex(where: { $0.id == item.id }) {
                                self.view?.reloadRow(at: index)
                            }
                        }
                    }
                }
            }
        }
    }

    /// 保管しているリポジトリのデータをリセット
    func reset() {
        order.current.items = []
        order.default.items = []
        order.desc.items = []
        order.asc.items = []
    }

    ///  APIから取得したデータを各リポジトリへセット
    func setSearchOrderItem(item: RepositoryItem) {
        let items = item.items!
        switch orderType {
        case .`default`:
            order.`default`.items = items
            order.current = order.`default`
        case .desc:
            order.desc.items = items
            order.current = order.desc
        case .asc:
            order.asc.items = items
            order.current = order.asc
        }
    }

    /// Starソート順のタイプとボタンの見た目を変更する
    func changeStarOrder() {
        switch orderType {
        case .`default`:
            orderType = .desc
            view?.didChangeStarOrder(searchItem: order.desc)
        case .desc:
            orderType = .asc
            view?.didChangeStarOrder(searchItem: order.asc)
        case .asc:
            orderType = .`default`
            view?.didChangeStarOrder(searchItem: order.default)
        }
    }

    /// もしリポジトリデータが空だった場合、APIからデータを取得する。データがすでにある場合はそれを使用する。
    func fetchOrSetSearchOrderItem() {
        let isEmptyWord = word.isEmpty

        switch orderType {
        case .`default`:
            if order.`default`.items.isEmpty && !isEmptyWord {
                order.current.items = []
                view?.startLoading()
                interactor.fetch(word: word, orderType: orderType)
            } else {
                order.current = order.default
            }
        case .desc:
            if order.desc.items.isEmpty && !isEmptyWord {
                order.current.items = []
                view?.startLoading()
                interactor.fetch(word: word, orderType: orderType)
            } else {
                order.current = order.desc
            }
        case .asc:
            if order.asc.items.isEmpty && !isEmptyWord {
                order.current.items = []
                view?.startLoading()
                interactor.fetch(word: word, orderType: orderType)
            } else {
                order.current = order.asc
            }
        }
    }

    /// API通信でエラーが返ってきた場合の処理
    func setAppearError(error: Error) {
        if error is ApiError {
            guard let apiError = error as? ApiError else { return }
            // 独自で定義したエラーを通知
            switch apiError {
            case .cancel: return
            case .notFound: view?.appearNotFound(message: apiError.errorDescription!)
            default: view?.appearErrorAlert(message: apiError.errorDescription!)
            }
        } else {
            //  標準のURLSessionのエラーを返す
            view?.appearErrorAlert(message: error.localizedDescription)
        }
    }
}
