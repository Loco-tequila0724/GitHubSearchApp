import UIKit

// View
protocol GitHubSearchView: AnyObject {
    var presenter: GitHubSearchPresentation! { get }
    func configure()
    func startLoading()
    func stopLoading()
    func tableViewReload()
    func resetDisplay()
    func appearErrorAlert(message: String)
    func appearNotFound(text: String)
    func didChangeStarOrder(starOrder: StarOrder)
}

// Presenter
protocol GitHubSearchPresentation: AnyObject {
    var view: GitHubSearchView? { get }
    var interactor: GitHubSearchInputUsecase { get }
    var router: GitHubSearchWireFrame { get }
    var items: [Item] { get }
    func viewDidLoad()
    /// サーチボタンのタップ通知
    func searchButtonDidPush(text: String)
    /// 検索テキストの変更を通知
    func searchTextDidChange()
    /// セルタップを通知
    func didSelectRow(item: Item)
    /// お気に入り順のボタンタップを通知
    func starOderButtonDidPush()
}

// Interactor インプット
protocol GitHubSearchInputUsecase: AnyObject {
    var presenter: GitHubSearchOutputUsecase? { get }
    /// gitHubApiにアクセスする
    var apiManager: ApiManager { get }
    /// API通信を行い、GitHubのデータをデータベースから取得
    func fetch(text: String)
}

// Interactor アウトプット
protocol GitHubSearchOutputUsecase: AnyObject {
    /// 取得したGitHubデータの結果をPresenterへ通知
    func didFetchResult(result: Result<GitHubSearchEntity, ApiError>)
}

// Router
protocol GitHubSearchWireFrame: AnyObject {
    static func assembleModules() -> UIViewController
    func showGitHubDetailViewController(item: Item)
}
