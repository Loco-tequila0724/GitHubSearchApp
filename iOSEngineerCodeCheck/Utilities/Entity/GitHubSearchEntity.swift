import Foundation

struct GitHubSearchEntity: Decodable {
    var items: [GitHubItem]?
}
// MARK: - GitHub リポジトリデータ構造 -
struct GitHubItem: Decodable {
    let fullName: String
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let owner: Owner

    enum CodingKeys: String, CodingKey {
        case language = "language"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case fullName = "full_name"
        case owner
    }
}

struct Owner: Decodable {
    let avatarUrl: URL

    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
