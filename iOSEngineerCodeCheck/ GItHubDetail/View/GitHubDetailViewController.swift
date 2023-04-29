import UIKit

final class GitHubDetailViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 7
        }
    }
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.minimumScaleFactor = 0.5
        }
    }
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var wathcersLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var issuesLabel: UILabel!

    private static let storyboardID = "GitHubDetailID"
    private static let storyboardName = "GitHubDetail"

    var presenter: GitHubDetailPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    deinit {
        let fileName = NSString(#file).lastPathComponent as NSString
        print(#function, " 🌀メモリが開放された", fileName)
    }
}

extension GitHubDetailViewController {
    static func instantiate() -> GitHubDetailViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let view = storyboard.instantiateViewController(withIdentifier: storyboardID) as? GitHubDetailViewController
        return view ?? GitHubDetailViewController()
    }
}

extension GitHubDetailViewController: GitHubDetailView {
    func configure() {
        setupNavigationBar(title: "リポジトリ")
        guard let gitHubItem = presenter.gitHubItem else { return }
        let imageURL = gitHubItem.owner.avatarUrl
        imageView.loadImageAsynchronous(url: imageURL)
        titleLabel.text = gitHubItem.fullName
        languageLabel.text = "言語 \(gitHubItem.language ?? "")"
        starsLabel.text    = "\(String(gitHubItem.stargazersCount))"
        wathcersLabel.text = "\(String(gitHubItem.watchersCount))"
        forksLabel.text    = "\(String(gitHubItem.forksCount))"
        issuesLabel.text   = "\(String(gitHubItem.openIssuesCount))"
    }
}
