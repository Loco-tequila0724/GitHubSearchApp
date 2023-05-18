import Foundation

final class GitHubSearchPresenter {
    weak var view: GitHubSearchView?
    var interactor: GitHubSearchInputUsecase
    var router: GitHubSearchWireFrame
    //  実際に表示に使用するGitHubリスト
    var items: [Item] = []
    //  一番最初に取得したデータを保管
    var defaultItems: [Item] = []
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
        items = []
        defaultItems = []
        view?.resetDisplay()
        view?.startLoading()
        interactor.fetch(text: text)
    }

    /// テキスト変更を検知。GitHubデータと画面の状態をリセット。タスクのキャンセル
    func searchTextDidChange() {
        items = []
        view?.resetDisplay()
        interactor.apiManager.task?.cancel()
    }

    /// セルタップの検知。DetailVCへ画面遷移通知。
    func didSelectRow(item: Item) {
        router.showGitHubDetailViewController(item: item)
    }

    /// スター数順の変更ボタンのタップを検知。(スター数で降順・昇順を切り替え)
    func starOderButtonDidPush() {
        switch starOrder {
        case .`default`:
            changeOrder(
                starOrder: .desc,
                // スター数が多い順にソート
                items: items.sorted { $0.stargazersCount > $01.stargazersCount }
            )
        case .desc:
            changeOrder(
                starOrder: .asc,
                // スター数が少ない順にソート
                items: items.sorted { $0.stargazersCount < $01.stargazersCount }
            )
        case .asc:
            changeOrder(
                starOrder: .default,
                // デフォルトの順番
                items: defaultItems
            )
        }
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
            self.defaultItems = gitHubData.items!
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
            items = defaultItems.sorted { $0.stargazersCount > $1.stargazersCount }
            view?.tableViewReload()
        case .asc:
            // スター数が少ない順にソート
            items = defaultItems.sorted { $0.stargazersCount < $1.stargazersCount }
            view?.tableViewReload()
        case .`default`:
            // デフォルトの順番
            items = defaultItems
            view?.tableViewReload()
        }
    }
}
// MARK: - このファイル内のみで使用する。 -
private extension GitHubSearchPresenter {
    /// スター数ボタンの状態によって、データを加工してViewに返す処理。
    func changeOrder(starOrder: StarOrder, items: [Item]) {
        // 現在のスター数の状態を保管
        self.starOrder = starOrder
        // Viewへ見た目の状態を返す
        view?.didChangeStarOrder(starOrder: starOrder)
        guard !items.isEmpty else { return }
        // GitHubデータがある場合は配列をソートして状態を保管
        self.items = items
        view?.tableViewReload()
    }
}
