import Foundation

final class GitHubSearchPresenter {
    weak var view: GitHubSearchViewController?
    var interactor: GitHubSearchInputUsecase
    var router: GitHubSearchWireFrame
    var gitHubRepository: [GitHubSearchEntity] = []

    init(
        view: GitHubSearchViewController? = nil,
        interactor: GitHubSearchInputUsecase,
        router: GitHubSearchWireFrame) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension GitHubSearchPresenter: GitHubPresentation {
    func viewDidLoad() {
    }

    func searchButtonDidPush() {
    }

    func cancelButtonDidPush() {
    }

    func didSelectRow() {
    }
}
