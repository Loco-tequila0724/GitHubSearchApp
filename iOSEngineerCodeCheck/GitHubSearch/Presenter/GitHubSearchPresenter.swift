import Foundation

final class GitHubSearchPresenter {
    weak var view: GitHubSearchViewController?
    var interactor: GitHubSearchInputUsecase
    var router: GitHubSearchWireFrame
    var gitHubList: [User] = []

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
        view?.configure()
    }

    func searchButtonDidPush(text: String) {
        Task {
            await interactor.fetchGitHubData(text: text)
        }
    }

    func cancelButtonDidPush() {
    }

    func didSelectRow() {
    }
}

extension GitHubSearchPresenter: GitHubSearchOutputUsecase {
    func didFetchGitHubResult(result: Result<GitHubSearchEntity, ApiError>) {
        switch result {
        case .success(let gitHubList):
            self.gitHubList = gitHubList.items ?? []
            view?.tableViewReload()
        case .failure(let error):
            print(error)
        }
    }
}
