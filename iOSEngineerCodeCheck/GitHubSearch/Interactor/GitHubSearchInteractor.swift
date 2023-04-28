import Foundation

final class GitHubSearchInteractor {
    weak var presenter: GitHubSearchOutputUsecase?
    private let decoder = JSONDecoder()
    var tast: Task<(), Never>?
}

extension GitHubSearchInteractor: GitHubSearchInputUsecase {

    /// データベースから GitHubデータを取得。
    func fetchGitHubData(text: String) {
        tast = Task {
            var gitHubRepository: (Result<GitHubSearchEntity, ApiError>)
            guard let url: URL = URL(string: "https://api.github.com/search/repositories?q=\(text)") else {
                gitHubRepository = .failure(.notFound)
                presenter?.didFetchGitHubResult(result: gitHubRepository)
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                let httpResponse = response as? HTTPURLResponse

                if httpResponse?.statusCode == 403 {
                    gitHubRepository = .failure(.forbidden)
                    presenter?.didFetchGitHubResult(result: gitHubRepository)
                    return
                }
                // リクエスト成功しなかったらエラーを返す
                guard httpResponse?.statusCode == 200 else {
                    gitHubRepository = .failure(.serverError)
                    presenter?.didFetchGitHubResult(result: gitHubRepository)
                    return
                }

                let gitHubList = try decoder.decode(GitHubSearchEntity.self, from: data)
                let isEmpty = (gitHubList.items?.compactMap { $0 }.isEmpty)!

                if isEmpty {
                    gitHubRepository = .failure(.notFound)
                    // gitHubのデータが空だった場合は、NotFoundエラーを渡す。
                    presenter?.didFetchGitHubResult(result: gitHubRepository)
                } else {
                    gitHubRepository = .success(gitHubList)
                    //  GitHubのデータを返す。
                    presenter?.didFetchGitHubResult(result: gitHubRepository)
                }
            } catch let error {
                // タスクがキャンセルされたらリターン
                if Task.isCancelled { return }

                gitHubRepository = .failure(.invalidData)
                presenter?.didFetchGitHubResult(result: gitHubRepository)
                Debug.log(errorDescription: error.localizedDescription)
            }
        }
    }
}
