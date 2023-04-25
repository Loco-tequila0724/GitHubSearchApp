import UIKit

struct GitHub {
    var items: [User]
}

struct User {
    let language: String
    let stargazersCount: String
    let wachersCount: String
    let forks_count: String
    let openIssuesCount: String
    let full_name: String

    let owner: [Owner]

    enum CodingKeys: String, CodingKey {
        case language = "language"
        case stargazersCount = "stargazers_count"
        case wachersCount = "wachers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
        case fullName = "full_name"
        case owner = "owner"

    }

    struct Owner {
        let avatar_url: String

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
        guard let text = searchBar.text, !text.isEmpty else { return }
        guard let url: URL = URL(string: "https://api.github.com/search/repositories?q=\(text)") else { return }

        task = URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data else { return }
            if let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let items = obj["items"] as? [[String: Any]] {
                    self.repository = items

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        task?.resume()
    }

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
