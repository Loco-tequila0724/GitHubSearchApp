import UIKit

final class GitHubDetailRouter {
    var viewController: UIViewController?

    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}

extension GitHubDetailRouter: GitHubDetailWireFrame {
    static func assembleModules(gitHub: User) -> UIViewController {
        let view = GitHubDetailViewController.instantiate()
        let router = GitHubDetailRouter(viewController: view)
        let presenter = GitHubDetailPresenter(
            view: view,
            router: router
        )

        view.presenter = presenter
        presenter.gitHub = gitHub

        return view
    }
}
