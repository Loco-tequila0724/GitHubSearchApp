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
    var repository: [[String: Any]] = []
    var task: URLSessionTask?
    var tappedRow: Int?
    private let decoder = JSONDecoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        }

    }

    func fetchGitHubData() async {
        guard let text = searchBar.text, !text.isEmpty else { return }
        guard let url: URL = URL(string: "https://api.github.com/search/repositories?q=\(text)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print("●～*")
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else { return }
            print("●～* 1")
            let gitHubRepository = try decoder.decode(GitHubRepository.self, from: data)
            print("●～* 2")
            print(gitHubRepository)
        } catch let error {
            print(error)
        }
    }

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchBar.text, !text.isEmpty else { return }
//        guard let url: URL = URL(string: "https://api.github.com/search/repositories?q=\(text)") else { return }
//
//        task = URLSession.shared.dataTask(with: url) { (data, _, _) in
//            guard let data else { return }
//            if let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                if let items = obj["items"] as? [[String: Any]] {
//                    self.repository = items
//
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
//                }
//            }
//        }
//        task?.resume()
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            let gitHubDetailVC = segue.destination as? GitHubDetailViewController
            gitHubDetailVC?.gitHubSearchVC = self
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = repository[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        tappedRow = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
