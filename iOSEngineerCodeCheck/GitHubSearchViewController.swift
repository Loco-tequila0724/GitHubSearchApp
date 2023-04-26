import UIKit

struct GitHubRepository: Decodable {
    var items: [User]?
}

struct User: Decodable {
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

    struct Owner: Decodable {
        let avatarUrl: URL

        enum CodingKeys: String, CodingKey {
            case avatarUrl = "avatar_url"
        }
    }
}

class GitHubSearchViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet private weak var searchBar: UISearchBar!
//    var repository: [[String: Any]] = []
    var repository: GitHubRepository?
    var task: URLSessionTask?
    var tappedRow: Int?
    private let decoder = JSONDecoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Task {
            await fetchGitHubData()
            await MainActor.run {
                self.tableView.reloadData()
            }
        }
    }

    func fetchGitHubData() async {
        guard let text = searchBar.text, !text.isEmpty else { return }
        guard let url: URL = URL(string: "https://api.github.com/search/repositories?q=\(text)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else { return }
            repository = try decoder.decode(GitHubRepository.self, from: data)

        } catch let error {
            print(error)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let gitHubDetailVC = segue.destination as? GitHubDetailViewController
            gitHubDetailVC?.gitHubSearchVC = self
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository?.items?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = repository?.items?[indexPath.row]
        cell.textLabel?.text = repository?.fullName
        cell.detailTextLabel?.text = repository?.language
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        tappedRow = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
