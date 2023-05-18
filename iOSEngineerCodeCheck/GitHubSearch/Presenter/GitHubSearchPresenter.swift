import Foundation

final class GitHubSearchPresenter {
    weak var view: GitHubSearchView?
    var interactor: GitHubSearchInputUsecase
    var router: GitHubSearchWireFrame
    //  実際に表示に使用するGitHubリスト
    var gitHubList: [GitHubItem] = []
    //  一番最初に取得したデータを保管
    var gitHubListDefault: [GitHubItem] = []
    //  Star数のボタンの状態を保管。(降順,昇順,デフォルト)
    var starOrder: StarOrder = .default

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
        gitHubListDefault = []
        view?.resetDisplay()
        view?.startLoading()
        interactor.fetchGitHubResult(text: text)
    }

    /// テキスト変更を検知。GitHubデータと画面の状態をリセット。タスクのキャンセル
    func searchTextDidChange() {
        gitHubList = []
        view?.resetDisplay()
        interactor.gitHubApi.task?.cancel()
    }

    /// セルタップの検知。DetailVCへ画面遷移通知。
    func didSelectRow(gitHubItem: GitHubItem) {
        router.showGitHubDetailVC(gitHubItem: gitHubItem)
    }

    /// スター数順の変更ボタンのタップを検知。(スター数で降順・昇順を切り替え)
    func starOderButtonDidPush() {
        switch starOrder {
        case .`default`:
            changeOrder(
                starOrder: .desc,
                // スター数が多い順にソート
                gitHubList: gitHubList.sorted { $0.stargazersCount > $01.stargazersCount }
            )
        case .desc:
            changeOrder(
                starOrder: .asc,
                // スター数が少ない順にソート
                gitHubList: gitHubList.sorted { $0.stargazersCount < $01.stargazersCount }
            )
        case .asc:
            changeOrder(
                starOrder: .default,
                // デフォルトの順番
                gitHubList: gitHubListDefault
            )
        }
    }
}

// MARK: - GitHubSearchOutputUsecase プロトコルに関する -
extension GitHubSearchPresenter: GitHubSearchOutputUsecase {
    /// GitHubデータをGitHubListへ加工しViewへ渡す。
    func didFetchGitHubResult(result: Result<GitHubSearchEntity, ApiError>) {
        view?.stopLoading()
        switch result {
        case .success(let gitHubData):
            //  データの取得が成功した場合は、 GitHubリストのデフォルトに保管。
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
        /// GitHubリストの順番をここでソートしてから、tableViewのリロード。
        switch starOrder {
        case .desc:
            // スター数が多い順にソート
            gitHubList = gitHubListDefault.sorted { $0.stargazersCount > $1.stargazersCount }
            view?.tableViewReload()
        case .asc:
            // スター数が少ない順にソート
            gitHubList = gitHubListDefault.sorted { $0.stargazersCount < $1.stargazersCount }
            view?.tableViewReload()
        case .`default`:
            // デフォルトの順番
            gitHubList = gitHubListDefault
            view?.tableViewReload()
        }
    }
}
// MARK: - このファイル内のみで使用する。 -
private extension GitHubSearchPresenter {
    /// スター数ボタンの状態によって、データを加工してViewに返す処理。
    func changeOrder(starOrder: StarOrder, gitHubList: [GitHubItem]) {
        // 現在のスター数の状態を保管
        self.starOrder = starOrder
        // Viewへ見た目の状態を返す
        view?.didChangeStarOrder(starOrder: starOrder)
        guard !gitHubList.isEmpty else { return }
        // GitHubデータがある場合は配列をソートして状態を保管
        self.gitHubList = gitHubList
        view?.tableViewReload()
    }
}
