import Foundation
// View
protocol GitHubSearchView {
    var presenter: GitHubPresentation { get }
    func configure()
    func startLoading()
    func stopLoading()
    func tableViewReload()
}
// Presenter
protocol GitHubPresentation {
    var view: GitHubSearchViewController? { get }
    var interactor: GitHubSearchInputUsecase { get }
    var router: GitHubSearchWireFrame { get }
//    var gitHubRepository: [] { get }
    func viewDidLoad()
    /// サーチボタンのタップ通知
    func searchButtonDidPush()
    /// キャンセルボタンのタップ通知
    func cancelButtonDidPush()
    /// セルタップを通知
    func didSelectRow()
}
// Interactor インプット
protocol GitHubSearchInputUsecase {
    var presenter: GitHubSearchOutputUsecase? { get }
    /// API通信を行い、GitHubのデータを取得
    func fetchGitHubData(text: String)
}
// Interactor アウトプット
protocol GitHubSearchOutputUsecase {
//    func didFetchGitHubResult(result: Result<[], erorr>)
}
// Router
protocol GitHubSearchWireFrame {
    static func assembleModules()
    func showGitHubDetailVC()
}
