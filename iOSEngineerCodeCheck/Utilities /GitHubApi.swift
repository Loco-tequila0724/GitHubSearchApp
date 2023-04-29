import Foundation

class GitHubApiManager {
    var decoder: JSONDecoder = JSONDecoder()
    var gitHubResult: (Result<GitHubSearchEntity, ApiError>)?
    var task: Task<(), Never>?
}
// MARK: - Iteraterから実際に呼び出すやつ -
extension GitHubApiManager {
    /// GitHubデータベースから取得した結果を返す。
    func fetch(text: String, completion: @escaping(Result<GitHubSearchEntity, ApiError>) -> Void) {
        task = Task {
            do {
                let request = try self.urlRequest(text: text)
                let gitHubData = try await convertGitHub(request: request)
                gitHubResult = .success(gitHubData)
                completion(gitHubResult!)
            } catch let apiError {
                // タスクをキャンセルされたらリターン
                if Task.isCancelled { return }
                gitHubResult = .failure(apiError as? ApiError ?? .unknown)
                completion(gitHubResult!)
            }
        }
    }
}
// MARK: - API通信を行なうための部品類 -
private extension GitHubApiManager {
    /// リクエスト生成。URLがない場合、NotFoundエラーを返す。
    func urlRequest(text: String) throws -> URLRequest {
        guard let url: URL = URL(string: "https://api.github.com/search/repositories?q=\(text)&per_page=60") else {
            throw ApiError.notFound
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
    /// API通信。デコード。GitHubデータへ変換。
    func convertGitHub(request: URLRequest) async throws -> GitHubSearchEntity {
        let (data, response) = try await URLSession.shared.data(for: request)
        let httpResponse = response as? HTTPURLResponse

        if httpResponse?.statusCode == 403 {
            throw ApiError.forbidden
        }
        // リクエスト成功しなかったらエラーを返す
        guard httpResponse?.statusCode == 200 else {
            throw ApiError.serverError
        }
        //
        let gitHubData = try decoder.decode(GitHubSearchEntity.self, from: data)

        // GitHubのItemsの中身が空だったらエラーを返す。
        let isEmpty = (gitHubData.items?.compactMap { $0 }.isEmpty)!
        if isEmpty { throw ApiError.notFound }

        return gitHubData
    }
}
