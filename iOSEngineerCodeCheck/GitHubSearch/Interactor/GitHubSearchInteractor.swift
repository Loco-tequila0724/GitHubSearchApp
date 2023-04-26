import Foundation

final class GitHubSearchInteractor {
    weak var presenter: GitHubSearchOutputUsecase?
}

extension GitHubSearchInteractor: GitHubSearchInputUsecase {
    func fetchGitHubData(text: String) {

    }
}
