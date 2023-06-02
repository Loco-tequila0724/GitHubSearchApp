//
//  GitHubSearchPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

final class GitHubSearchPresenter {
    weak var view: GitHubSearchView?
    var interactor: GitHubSearchInputUsecase
    var router: GitHubSearchWireFrame
    var order = OrderItemManager()
    private var orderType: Order = .default
    private var word: String = ""

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
    func viewDidLoad() {
        view?.configure()
    }

    /// 検索ボタンのタップを検知。 GitHubデータのリセット。ローディングの開始。GitHubデータの取得を通知。
    func searchButtonDidPush(word: String) {
        reset()
        self.word = word
        view?.resetDisplay()
        view?.startLoading()
        interactor.fetch(url: url)
    }

    /// テキスト変更を検知。GitHubデータと画面の状態をリセット。タスクのキャンセル
    func searchTextDidChange() {
        word = ""
        reset()
        view?.resetDisplay()
        interactor.apiManager.task?.cancel()
    }

    /// セルタップの検知。DetailVCへ画面遷移通知。
    func didSelectRow(item: Item) {
        router.showGitHubDetailViewController(item: item)
    }

    /// スター数順の変更ボタンのタップを検知。(スター数で降順・昇順を切り替え)
    func starOderButtonDidPush() {
        changeStarOrder()
        fetchOrSetSearchOrderItem()
        view?.tableViewReload()
    }
}

// MARK: - GitHubSearchOutputUsecase プロトコルに関する -
extension GitHubSearchPresenter: GitHubSearchOutputUsecase {
    /// GitHubリポジトリデータを各リポジトリ (デフォルト, 降順, 昇順) に保管しテーブルビューへ表示。
    func didFetchResult(result: Result<RepositoryItem, Error>) {
        view?.stopLoading()
        switch result {
        case .success(let item):
            setSearchOrderItem(item: item)
            view?.tableViewReload()
        case .failure(let error):
            setAppearError(error: error)
        }
    }
}

private extension GitHubSearchPresenter {
    var url: URL? {
        switch orderType {
        case .`default`: return order.`default`.url(word: word)
        case .desc: return order.desc.url(word: word)
        case .asc: return order.asc.url(word: word)
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
                interactor.fetch(url: url)
            } else {
                order.current = order.default
            }
        case .desc:
            if order.desc.items.isEmpty && !isEmptyWord {
                order.current.items = []
                view?.startLoading()
                interactor.fetch(url: url)
            } else {
                order.current = order.desc
            }
        case .asc:
            if order.asc.items.isEmpty && !isEmptyWord {
                order.current.items = []
                view?.startLoading()
                interactor.fetch(url: url)
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
