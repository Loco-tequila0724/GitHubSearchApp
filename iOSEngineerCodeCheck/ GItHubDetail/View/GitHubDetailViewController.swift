import UIKit

final class GitHubDetailViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
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
    static let storyboardID = "GitHubDetailID"
    static let storyboardName = "GitHubDetail"

    var presenter: GitHubDetailPresenter!

    static func instantiate() -> GitHubDetailViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let view = storyboard.instantiateViewController(withIdentifier: storyboardID) as? GitHubDetailViewController
        return view ?? GitHubDetailViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    deinit {
        let fileName = NSString(#file).lastPathComponent as NSString
        print(#function, " 🌀メモリが開放された", fileName)
    }
}

extension GitHubDetailViewController: GitHubDetailView {
    func configure() {
        guard let gitHub = presenter.gitHub else { return }
        let imageURL = gitHub.owner.avatarUrl
        imageView.loadImageAsynchronous(url: imageURL)
        titleLabel.text = gitHub.fullName
        languageLabel.text = "Written in \(gitHub.language ?? "")"
        starsLabel.text = "\(String(gitHub.stargazersCount)) stars"
        wathcersLabel.text = "\(String(gitHub.watchersCount)) watchers"
        forksLabel.text = "\(String(gitHub.forksCount)) forks"
        issuesLabel.text = "\(String(gitHub.openIssuesCount)) open issues"
    }
}
