import Foundation

final class GitHubSearchInteractor {
    weak var presenter: GitHubSearchOutputUsecase?
    private let decoder = JSONDecoder()
}

extension GitHubSearchInteractor: GitHubSearchInputUsecase {
    /// データベースから GitHubデータを取得。
    func fetchGitHubData(text: String) async {
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
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                gitHubRepository = .failure(.serverError)
                return
            }

            let gitHubList = try decoder.decode(GitHubSearchEntity.self, from: data)
            gitHubRepository = .success(gitHubList)
            presenter?.didFetchGitHubResult(result: gitHubRepository)
        } catch let error {
            gitHubRepository = .failure(.invalidData)
            presenter?.didFetchGitHubResult(result: gitHubRepository)
            Debug.log(errorDescription: error.localizedDescription)
        }
    }
}
