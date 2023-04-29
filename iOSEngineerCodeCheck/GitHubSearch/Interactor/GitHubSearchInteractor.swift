import Foundation

final class GitHubSearchInteractor {
    weak var presenter: GitHubSearchOutputUsecase?
    let gitHubApi = GitHubApiManager()

}

extension GitHubSearchInteractor: GitHubSearchInputUsecase {
    /// データベースから GitHubデータを取得。
    func fetchGitHubResult(text: String) {
        gitHubApi.fetch(text: text) { [weak self] result in
            self?.presenter?.didFetchGitHubResult(result: result)
        }
    }
}
