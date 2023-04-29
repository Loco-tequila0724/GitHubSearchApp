import Foundation

final class GitHubSearchPresenter {
    weak var view: GitHubSearchView?
    var interactor: GitHubSearchInputUsecase
    var router: GitHubSearchWireFrame
    var gitHubList: [GitHubItem] = []
    var gitHubListDefault: [GitHubItem] = []
    var starOrder: StarOrder = .`default`

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
    func starOderButtonDidPush() {
        switch starOrder {
        case .`default`:
            starOrder = .desc
            view?.didChangeStarOrder(starOrder: starOrder)
            guard !gitHubList.isEmpty else { return }
            gitHubList = gitHubList.sorted { $0.stargazersCount > $01.stargazersCount }
            view?.tableViewReload()
        case .desc:
            starOrder = .ask
            view?.didChangeStarOrder(starOrder: starOrder)
            guard !gitHubList.isEmpty else { return }
            gitHubList = gitHubList.sorted { $0.stargazersCount < $01.stargazersCount }
            view?.tableViewReload()
        case .ask:
            starOrder = .`default`
            view?.didChangeStarOrder(starOrder: starOrder)
            guard !gitHubList.isEmpty else { return }
            gitHubList = gitHubListDefault
            view?.tableViewReload()
        }
    }
    // 使うかも
    func ssss(starOrder: StarOrder) {
        self.starOrder = starOrder
        view?.didChangeStarOrder(starOrder: starOrder)
        guard !gitHubList.isEmpty else { return }
        view?.tableViewReload()
    }

    func viewDidLoad() {
        view?.configure()
    }
    /// 検索ボタンのタップを検知。 GitHubデータのリセット。ローディングの開始。GitHubデータの取得を通知。
    func searchButtonDidPush(text: String) {
        gitHubList = []
        view?.resetGitList()
        view?.startLoading()
        interactor.fetchGitHubResult(text: text)
    }
    /// テキスト変更を検知。GitHubデータと画面の状態をリセット。タスクのキャンセル
    func searchTextDidChange() {
        gitHubList = []
        view?.resetGitList()
        interactor.gitHubApi.task?.cancel()
    }
    /// セルタップの検知。DetailVCへ画面遷移通知。
    func didSelectRow(gitHub: GitHubItem) {
        router.showGitHubDetailVC(gitHub: gitHub)
    }
}

extension GitHubSearchPresenter: GitHubSearchOutputUsecase {
    /// GitHubデータをGitHubListへ加工しViewへ渡す。
    func didFetchGitHubResult(result: Result<GitHubSearchEntity, ApiError>) {
        view?.stopLoading()
        switch result {
        case .success(let gitHubData):
            self.gitHubListDefault = gitHubData.items!
        case .failure(let error):
            if error == .notFound {
                // GitHubの結果が無いことを通知
                view?.appearNotFound(text: error.errorDescription!)
            } else {
                // エラー内容を通知。
                view?.appearErrorAlert(message: error.errorDescription!)
            }
        }
        switch starOrder {
        case .desc:
            gitHubList = gitHubListDefault.sorted { $0.stargazersCount > $1.stargazersCount }
            view?.tableViewReload()
        case .ask:
            gitHubList = gitHubListDefault.sorted { $0.stargazersCount < $1.stargazersCount }
            view?.tableViewReload()
        case .`default`:
            gitHubList = gitHubListDefault
            view?.tableViewReload()
        }
    }
}
