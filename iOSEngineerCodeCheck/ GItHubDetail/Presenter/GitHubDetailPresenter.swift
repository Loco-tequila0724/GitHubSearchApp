import Foundation

final class GitHubDetailPresenter {
    weak var view: GitHubDetailView?
    var router: GitHubDetailRouter?
    var gitHub: User?

    init(
        view: GitHubDetailView? = nil,
        router: GitHubDetailRouter? = nil) {
        self.view = view
        self.router = router
    }
}

extension GitHubDetailPresenter: GitHubDetailPresentation {
    func viewDidLoad() {
        view?.configure()
    }
}
