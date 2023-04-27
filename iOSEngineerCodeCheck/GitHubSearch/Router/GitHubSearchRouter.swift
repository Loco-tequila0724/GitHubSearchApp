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

    func showGitHubDetailVC(gitHub: GitHubItem) {
        let gitHubDetailRouterVC = GitHubDetailRouter.assembleModules(gitHubItem: gitHub)
        viewController?.navigationController?.pushViewController(gitHubDetailRouterVC, animated: true)
    }
}
