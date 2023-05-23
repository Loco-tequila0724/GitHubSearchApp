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
    func searchButtonDidPush(word: String) {
        reset()
        view?.resetDisplay()
        view?.startLoading()
        interactor.fetch(word: word)
    }

    /// テキスト変更を検知。GitHubデータと画面の状態をリセット。タスクのキャンセル
    func searchTextDidChange() {
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
    /// GitHubリポジトリデータを各リポジトリ (デフォルト, 降順, 昇順) に保管しテーブルビューへ表示。
    func didFetchResult(result: Result<GitHubRepositories, Error>) {
        view?.stopLoading()

        switch result {
        case .success(let item):
            setRepositoryItem(item: item)
            setCurrentRepository()
            view?.tableViewReload()
        case .failure(let error):
            setAppearError(error: error)
        }
    }
}

private extension GitHubSearchPresenter {
    /// 保管しているリポジトリのデータをリセット
    func reset() {
        repository.current.items = []
        repository.default.items = []
        repository.desc.items = []
        repository.asc.items = []
    }

    ///  APIから取得したデータを各リポジトリへセット
    func setRepositoryItem(item: GitHubRepositories) {
        repository.`default`.items = item.`default`.items!
        repository.desc.items = item.desc.items!
        repository.asc.items = item.asc.items!
    }

    ///  現在の画面に使用するためのリポジトリをセット
    func setCurrentRepository() {
        switch order {
        case .`default`:
            repository.current = repository.`default`
        case .desc:
            repository.current = repository.desc
        case .asc:
            repository.current = repository.asc
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
