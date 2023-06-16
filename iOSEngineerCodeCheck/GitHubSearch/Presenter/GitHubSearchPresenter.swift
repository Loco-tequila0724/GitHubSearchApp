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
    private let interactor: GitHubSearchInputUsecase
    private let router: GitHubSearchWireFrame

    init(
        view: GitHubSearchView,
        interactor: GitHubSearchInputUsecase,
        router: GitHubSearchWireFrame) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension GitHubSearchPresenter: GitHubSearchPresentation {
    var numberOfRow: Int {
        interactor.itemsCount
    }

    func item(at index: Int) -> GitHubSearchViewItem {
        interactor.viewItem(at: index)
    }

    func viewDidLoad() {
        view?.setUp()
    }

    func willDisplayRow(at index: Int) {
        interactor.fetchAvatarImages(at: index)
    }

    /// 検索ボタンのタップを検知。 GitHubデータと画面表示をリセット。ローディングの開始。GitHubデータの取得を通知。
    func searchButtonDidPush(word: String) {
        view?.resetDisplay()
        view?.startLoading()
        interactor.search(word: word)
    }

    /// テキスト変更を検知。GitHubデータと画面表示をリセット。
    func searchTextDidChange() {
        view?.resetDisplay()
        interactor.cancelFetchingAndResetRepository()
    }

    /// セルタップの検知。DetailVCへ画面遷移通知。
    func didSelectRow(at index: Int) {
        let item = interactor.currentItem(at: index)
        router.showGitHubDetailViewController(item: item)
    }

    /// スター数順の変更ボタンのタップを検知。(スター数で降順・昇順を切り替え)
    func starOderButtonDidPush() {
        let order = interactor.nextOrder
        interactor.changeRepositoryItem()
        view?.didChangeStarOrder(order: order)
        view?.tableViewReload()
    }
}

extension GitHubSearchPresenter: GitHubSearchOutputUsecase {
    func didFetchSuccess() {
        view?.stopLoading()
        view?.tableViewReload()
    }

    func didFetchError(error: Error) {
        view?.stopLoading()
        setAppearError(error: error)
    }

    func startLoading() {
        view?.startLoading()
    }

    func didFetchAvatarImage(item: GitHubSearchViewItem, at index: Int) {
        view?.configure(item: item, at: index)
    }
}

private extension GitHubSearchPresenter {
    /// API通信でエラーが返ってきた場合の処理
    func setAppearError(error: Error) {
        if error is APIError {
            guard let apiError = error as? APIError else { return }
            // 独自で定義したエラーを通知
            switch apiError {
            case .cancel: return
            case .notFound: view?.appearNotFound(message: apiError.errorDescription!)
            default: view?.appearErrorAlert(message: apiError.errorDescription!)
            }
        } else {
            // 標準のURLSessionのエラーを返す
            view?.appearErrorAlert(message: error.localizedDescription)
        }
    }
}
