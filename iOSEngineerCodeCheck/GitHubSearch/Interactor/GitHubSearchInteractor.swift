import Foundation

final class GitHubSearchInteractor {
    weak var presenter: GitHubSearchOutputUsecase?
    let apiManager = ApiManager()
}

extension GitHubSearchInteractor: GitHubSearchInputUsecase {
    /// データベースから GitHubデータを取得。
    func fetch(text: String) {
        apiManager.fetch(text: text) { [weak self] result in
            self?.presenter?.didFetchResult(result: result)
        }
    }
}
