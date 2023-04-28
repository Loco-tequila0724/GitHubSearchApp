import UIKit
// View
protocol GitHubSearchView: AnyObject {
    var presenter: GitHubSearchPresentation! { get }
    func configure()
    func startLoading()
    func stopLoading()
    func tableViewReload()
    func resetGitList()
    func appearErrorAlert(message: String)
    func appearNotFound(text: String)
}
// Presenter
protocol GitHubSearchPresentation: AnyObject {
    var view: GitHubSearchView? { get }
    var interactor: GitHubSearchInputUsecase { get }
    var router: GitHubSearchWireFrame { get }
    var gitHubList: [GitHubItem] { get }
    func viewDidLoad()
    /// サーチボタンのタップ通知
    func searchButtonDidPush(text: String)
    /// 検索テキストの変更を通知
    func searchTextDidChange()
    /// セルタップを通知
    func didSelectRow(gitHub: GitHubItem)
}
// Interactor インプット
protocol GitHubSearchInputUsecase: AnyObject {
    var presenter: GitHubSearchOutputUsecase? { get }
    var tast: Task<(), Never>? { get }
    /// API通信を行い、GitHubのデータをデータベースから取得
    func fetchGitHubData(text: String)
}
// Interactor アウトプット
protocol GitHubSearchOutputUsecase: AnyObject {
    /// 取得したデータの結果を加工する
    func didFetchGitHubResult(result: Result<GitHubSearchEntity, ApiError>)
}
// Router
protocol GitHubSearchWireFrame: AnyObject {
    static func assembleModules() -> UIViewController
    func showGitHubDetailVC(gitHub: GitHubItem)
}
