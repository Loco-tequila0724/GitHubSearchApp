import UIKit

final class GitHubDetailRouter {
    private weak var viewController: UIViewController?

    private init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}

extension GitHubDetailRouter: GitHubDetailWireFrame {
    static func assembleModules(gitHubItem: GitHubItem) -> UIViewController {
        let view = GitHubDetailViewController.instantiate()
        let router = GitHubDetailRouter(viewController: view)
        let presenter = GitHubDetailPresenter(
            view: view,
            router: router
        )

        view.presenter = presenter
        presenter.gitHubItem = gitHubItem

        return view
    }
}
