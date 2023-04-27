import UIKit

final class GitHubSearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var notFoundLabel: UILabel!
    @IBOutlet private weak var frontView: UIView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

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
        presenter.viewDidLoad()
    }
}

extension GitHubSearchViewController: GitHubSearchView {
    func configure() {
        searchBar.placeholder = "GitHubのリポジトリを検索"
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        notFoundLabel.text = nil
        frontView.isHidden = true
    }

    func resetGitList() {
        DispatchQueue.main.async {
            self.frontView.isHidden = true
            self.indicatorView.isHidden = true
            self.notFoundLabel.isHidden = true
            self.tableView.reloadData()
        }
    }

    func startLoading() {
        DispatchQueue.main.async {
            self.indicatorView.startAnimating()
            self.frontView.isHidden = false
            self.indicatorView.isHidden = false
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
            self.frontView.isHidden = true
            self.indicatorView.isHidden = true
        }
    }

    func appearErrorAlert(message: String) {
        self.errorAlert(message: message)
    }

    func appearNotFound(text: String) {
        DispatchQueue.main.async {
            self.indicatorView.stopAnimating()
            self.frontView.isHidden = false
            self.indicatorView.isHidden = true
            self.notFoundLabel.isHidden = false
            self.notFoundLabel.text = text
        }
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
        searchBar.resignFirstResponder()
    }
}

extension GitHubSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.gitHubList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GitHubSearchTableViewCell.identifier) as? GitHubSearchTableViewCell else { return UITableViewCell() } // swiftlint:disable:this all
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
        let gitHub = presenter.gitHubList[indexPath.row]
        presenter.didSelectRow(gitHub: gitHub)
    }
}
