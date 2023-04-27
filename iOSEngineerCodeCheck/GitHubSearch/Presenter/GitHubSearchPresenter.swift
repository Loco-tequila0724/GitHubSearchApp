import Foundation

final class GitHubSearchPresenter {
    weak var view: GitHubSearchView?
    var interactor: GitHubSearchInputUsecase
    var router: GitHubSearchWireFrame
    var gitHubList: [User] = []

    init(
        view: GitHubSearchView? = nil,
        interactor: GitHubSearchInputUsecase,
        router: GitHubSearchWireFrame) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension GitHubSearchPresenter: GitHubSearchPresentation {
    func viewDidLoad() {
        view?.configure()
    }

    func searchButtonDidPush(text: String) {
        gitHubList = []
        view?.resetGitList()
        view?.startLoading()
        Task {
            await interactor.fetchGitHubData(text: text)
        }
    }

    func searchTextDidChange() {
        gitHubList = []
        view?.resetGitList()
    }

    func searchBarCancelButtonClicked() {
        gitHubList = []
        view?.resetGitList()
    }

    func didSelectRow(gitHub: User) {
        router.showGitHubDetailVC(gitHub: gitHub)
    }
}

extension GitHubSearchPresenter: GitHubSearchOutputUsecase {
    func didFetchGitHubResult(result: Result<GitHubSearchEntity, ApiError>) {
        view?.stopLoading()
        switch result {
        case .success(let gitHubList):
            self.gitHubList = gitHubList.items ?? []
            view?.tableViewReload()
        case .failure(let error):
            if error == .notFound {
                view?.appearNotFound(text: error.errorDescription!)
            } else {
                view?.appearErrorAlert(message: error.errorDescription!)
                Debug.log(errorDescription: error.errorDescription!)
            }
        }
    }
}
