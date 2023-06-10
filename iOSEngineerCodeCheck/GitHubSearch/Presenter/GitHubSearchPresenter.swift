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
        interactor.items.count
    }

    func viewDidLoad() {
        view?.configure()
    }

    /// 検索ボタンのタップを検知。 GitHubデータのリセット。ローディングの開始。GitHubデータの取得を通知。
    func searchButtonDidPush(word: String) {
        interactor.search(word: word)
        view?.resetDisplay()
        view?.startLoading()
    }

    /// テキスト変更を検知。GitHubデータと画面の状態をリセット。タスクのキャンセル
    func searchTextDidChange() {
        interactor.cancelFetching()
        view?.resetDisplay()
    }

    /// セルタップの検知。DetailVCへ画面遷移通知。
    func didSelectRow(at index: Int) {
        let item = interactor.items[index]
        router.showGitHubDetailViewController(item: item)
    }

    /// スター数順の変更ボタンのタップを検知。(スター数で降順・昇順を切り替え)
    func starOderButtonDidPush() {
        interactor.changeOrder()

        view?.didChangeStarOrder(searchItem: interactor.items, order: interactor.orderType)
        view?.startLoading()
        view?.tableViewReload()
    }

    func item(at index: Int) -> GitHubSearchViewItem {
        interactor.item(at: index)
    }
}

// MARK: - GitHubSearchOutputUsecase プロトコルに関する -
extension GitHubSearchPresenter: GitHubSearchOutputUsecase {
    func didFetchAvatarImage(at index: Int) {
        view?.reloadRow(at: index)
    }

    func didFetchSuccess() {
        view?.stopLoading()
        view?.tableViewReload()
    }

    func didFetchError(error: Error) {
        view?.stopLoading()
        setAppearError(error: error)
    }
}

private extension GitHubSearchPresenter {
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
