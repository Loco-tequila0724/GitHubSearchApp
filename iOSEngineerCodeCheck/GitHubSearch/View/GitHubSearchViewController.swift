import UIKit

final class GitHubSearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet private weak var searchBar: UISearchBar!
    private(set) var repository: GitHubSearchEntity?
    private(set) var tappedRow: Int?
    private var task: URLSessionTask?
    private let decoder = JSONDecoder()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "GitHubのリポジトリを検索"
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.placeholder = ""
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

    private func fetchGitHubData() async {
        guard let text = searchBar.text, !text.isEmpty else { return }
        guard let url: URL = URL(string: "https://api.github.com/search/repositories?q=\(text)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else { return }
            repository = try decoder.decode(GitHubSearchEntity.self, from: data)
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
}

extension GitHubSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository?.items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable line_length
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GitHubSearchTableViewCell.identifier) as? GitHubSearchTableViewCell else { return UITableViewCell() }
        // swiftlint:enable line_length
        let repository = repository?.items?[indexPath.row]

        cell.configure(
            fullName: repository?.fullName ?? "",
            language: repository?.language ?? ""
        )

        return cell
    }
}

extension GitHubSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedRow = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}