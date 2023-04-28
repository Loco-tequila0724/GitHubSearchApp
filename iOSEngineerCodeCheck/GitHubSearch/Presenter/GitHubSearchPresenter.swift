import Foundation

final class GitHubSearchPresenter {
    weak var view: GitHubSearchView?
    var interactor: GitHubSearchInputUsecase
    var router: GitHubSearchWireFrame
    var gitHubList: [GitHubItem] = []

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
    /// GitHubデータを加工しViewへ通知。
    func didFetchGitHubResult(result: Result<GitHubSearchEntity, ApiError>) {
        view?.stopLoading()
        switch result {
        case .success(let gitHubData):
            self.gitHubList = gitHubData.items!
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
