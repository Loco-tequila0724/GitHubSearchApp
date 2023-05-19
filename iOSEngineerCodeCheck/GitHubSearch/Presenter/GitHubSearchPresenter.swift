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
    var repository = RepositoryManager()
    var order: Order = .default

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
    func searchButtonDidPush(repositoryItem: RepositoryItem) {
        resetRepository()
        view?.resetDisplay()
        view?.startLoading()
        interactor.fetch(orderRepository: repositoryItem)
    }

    /// テキスト変更を検知。GitHubデータと画面の状態をリセット。タスクのキャンセル
    func searchTextDidChange() {
        resetRepository()
        view?.resetDisplay()
        interactor.apiManager.task?.cancel()
    }

    /// セルタップの検知。DetailVCへ画面遷移通知。
    func didSelectRow(item: Item) {
        router.showGitHubDetailViewController(item: item)
    }
    /// スター数順の変更ボタンのタップを検知。(スター数で降順・昇順を切り替え)
    func starOderButtonDidPush() {
        switch order {
        case .`default`:
            order = .desc
            repository.current = repository.desc
        case .desc:
            order = .asc
            repository.current = repository.asc
        case .asc:
            order = .`default`
            repository.current = repository.`default`
        }

        view?.didChangeStarOrder(repository: repository.current)
        view?.tableViewReload()
    }
}

// MARK: - GitHubSearchOutputUsecase プロトコルに関する -
extension GitHubSearchPresenter: GitHubSearchOutputUsecase {
    /// GitHubデータをGitHubListへ加工しViewへ渡す。
    func didFetchResult(result: Result<GitHubSearchEntity, ApiError>) {
        view?.stopLoading()
        switch result {
        case .success(let gitHubData):
            repository.current.items = gitHubData.items!

            switch order {
            case .`default`:
                repository.`default`.items = gitHubData.items!
            case .desc:
                repository.desc.items = gitHubData.items!
            case .asc:
                repository.asc.items = gitHubData.items!
            }
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

private extension GitHubSearchPresenter {
    func resetRepository() {
        repository.current.items = []
        repository.default.items = []
        repository.desc.items = []
        repository.asc.items = []
    }
}
