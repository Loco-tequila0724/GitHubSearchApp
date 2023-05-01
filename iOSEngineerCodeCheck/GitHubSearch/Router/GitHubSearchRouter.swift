import UIKit

final class GitHubSearchRouter {
    private weak var viewController: UIViewController?

    private init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}

extension GitHubSearchRouter: GitHubSearchWireFrame {
    static func assembleModules() -> UIViewController {
        let view = GitHubSearchViewController.instantiate()
        let interactor = GitHubSearchInteractor()
        let router = GitHubSearchRouter(viewController: view)
        let presenter = GitHubSearchPresenter(
            view: view,
            interactor: interactor,
            router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        return view
    }

    func showGitHubDetailVC(gitHubItem: GitHubItem) {
        // GitHubのデータはここで持たせて次の画面に渡します。
        let gitHubDetailRouterVC = GitHubDetailRouter.assembleModules(gitHubItem: gitHubItem)
        viewController?.navigationController?.pushViewController(gitHubDetailRouterVC, animated: true)
    }
}
