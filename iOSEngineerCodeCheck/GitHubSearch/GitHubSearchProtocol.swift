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
// Presentergi
protocol GitHubSearchPresentation: AnyObject {
    var view: GitHubSearchView? { get }
    var interactor: GitHubSearchInputUsecase { get }
    var router: GitHubSearchWireFrame { get }
    var gitHubList: [User] { get }
    func viewDidLoad()
    /// サーチボタンのタップ通知
    func searchButtonDidPush(text: String)
    /// キャンセルボタンのタップ通知
    func cancelButtonDidPush()
    /// セルタップを通知
    func didSelectRow(gitHub: User)
}
// Interactor インプット
protocol GitHubSearchInputUsecase: AnyObject {
    var presenter: GitHubSearchOutputUsecase? { get }
    /// API通信を行い、GitHubのデータを取得
    func fetchGitHubData(text: String) async
}
// Interactor アウトプット
protocol GitHubSearchOutputUsecase: AnyObject {
    func didFetchGitHubResult(result: Result<GitHubSearchEntity, ApiError>)
}
// Router
protocol GitHubSearchWireFrame: AnyObject {
    static func assembleModules() -> UIViewController
    func showGitHubDetailVC(gitHub: User)
}
