import UIKit

final class GitHubSearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
//    private(set) var tappedRow: Int?
    private static let storyboardID = "GitHubSearchID"
    private static let storyboardName = "Main"
    var presenter: GitHubSearchPresentation!

    static func instantiate() -> GitHubSearchViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let view = storyboard.instantiateViewController(withIdentifier: storyboardID) as? GitHubSearchViewController
        return view ?? GitHubSearchViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension GitHubSearchViewController: GitHubSearchView {
    func configure() {
        searchBar.placeholder = "GitHubのリポジトリを検索"
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }

    func startLoading() {
    }

    func stopLoading() {
    }

    func tableViewReload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension GitHubSearchViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.placeholder = ""
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//      task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        presenter.searchButtonDidPush(text: text)
    }
}

extension GitHubSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.gitHubList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable line_length
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GitHubSearchTableViewCell.identifier) as? GitHubSearchTableViewCell else { return UITableViewCell() }
        // swiftlint:enable line_length
        let gitHub = presenter.gitHubList[indexPath.row]

        cell.configure(
            fullName: gitHub.fullName,
            language: gitHub.language ?? ""
        )
        return cell
    }
}

extension GitHubSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tappedRow = indexPath.row
        let gitHub = presenter.gitHubList[indexPath.row]
        presenter.didSelectRow(gitHub: gitHub)
    }
}
