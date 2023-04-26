import Foundation
// View
protocol GitHubSearchView: AnyObject {
    var presenter: GitHubPresentation { get }
    func configure()
    func startLoading()
    func stopLoading()
    func tableViewReload()
}
// Presenter
protocol GitHubPresentation: AnyObject {
    var view: GitHubSearchViewController? { get }
    var interactor: GitHubSearchInputUsecase { get }
    var router: GitHubSearchWireFrame { get }
    var gitHubRepository: [GitHubSearchEntity] { get }
    func viewDidLoad()
    /// サーチボタンのタップ通知
    func searchButtonDidPush()
    /// キャンセルボタンのタップ通知
    func cancelButtonDidPush()
    /// セルタップを通知
    func didSelectRow()
}
// Interactor インプット
protocol GitHubSearchInputUsecase: AnyObject {
    var presenter: GitHubSearchOutputUsecase? { get }
    /// API通信を行い、GitHubのデータを取得
    func fetchGitHubData(text: String)
}
// Interactor アウトプット
protocol GitHubSearchOutputUsecase: AnyObject {
    func didFetchGitHubResult(result: Result<[GitHubSearchEntity], ApiError>)
}
// Router
protocol GitHubSearchWireFrame: AnyObject {
    static func assembleModules()
    func showGitHubDetailVC()
}
