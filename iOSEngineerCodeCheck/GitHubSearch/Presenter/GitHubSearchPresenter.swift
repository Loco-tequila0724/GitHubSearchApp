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

    var orderRepository: OrderRepository!

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
    func searchButtonDidPush(orderRepository: OrderRepository) {
        view?.resetDisplay()
        view?.startLoading()
        interactor.fetch(orderRepository: orderRepository)
    }

    /// テキスト変更を検知。GitHubデータと画面の状態をリセット。タスクのキャンセル
    func searchTextDidChange() {
        view?.resetDisplay()
        interactor.apiManager.task?.cancel()
    }

    /// セルタップの検知。DetailVCへ画面遷移通知。
    func didSelectRow(item: Item) {
        router.showGitHubDetailViewController(item: item)
    }

    /// スター数順の変更ボタンのタップを検知。(スター数で降順・昇順を切り替え)
    func starOderButtonDidPush() {
//        switch starOrder {
//        case .`default`:
//            changeOrder(
//                starOrder: .desc,
//                // スター数が多い順にソート
//                items: items.sorted { $0.stargazersCount > $01.stargazersCount }
//            )
//        case .desc:
//            changeOrder(
//                starOrder: .asc,
//                // スター数が少ない順にソート
//                items: items.sorted { $0.stargazersCount < $01.stargazersCount }
//            )
//        case .asc:
//            changeOrder(
//                starOrder: .default,
//                // デフォルトの順番
//                items: defaultItems
//            )
//        }
    }
}

// MARK: - GitHubSearchOutputUsecase プロトコルに関する -
extension GitHubSearchPresenter: GitHubSearchOutputUsecase {
    /// GitHubデータをGitHubListへ加工しViewへ渡す。
    func didFetchResult(result: Result<GitHubSearchEntity, ApiError>) {
        view?.stopLoading()
        switch result {
        case .success(let gitHubData):
            //  データの取得が成功した場合は、 GitHubリストのデフォルトに保管。
            self.orderRepository?.items = gitHubData.items!
            view?.tableViewReload()
        case .failure(let error):
            if error == .notFound {
                // GitHubの結果が無いことを通知
                view?.appearNotFound(text: error.errorDescription!)
            } else {
                // エラー内容を通知。
                view?.appearErrorAlert(message: error.errorDescription!)
            }
        }
    }
}
// MARK: - このファイル内のみで使用する。 -
private extension GitHubSearchPresenter {
}
