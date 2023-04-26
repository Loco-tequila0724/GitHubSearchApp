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

    var gitHubSearchVC: GitHubSearchViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
//        let repository = gitHubSearchVC.repository?.items?[gitHubSearchVC.tappedRow ?? 0]
//        languageLabel.text = repository?.language
//        wathcersLabel.text = String(repository?.watchersCount ?? 0)
//        forksLabel.text = String(repository?.forksCount ?? 0)
//        issuesLabel.text = String(repository?.openIssuesCount ?? 0)
//        Task {
//            await getImage()
//        }
    }

    deinit {
        let fileName = NSString(#file).lastPathComponent as NSString
        print(#function, " 🌀メモリが開放された", fileName)
    }

    private func getImage() async {
//        let repo = gitHubSearchVC.repository?.items?[gitHubSearchVC.tappedRow ?? 0]
//        titleLabel.text = repo?.fullName
//        let imageURL = repo?.owner.avatarUrl
//        guard let imageURL else { return }
//        var request = URLRequest(url: imageURL)
//
//        do {
//            let (data, response) = try await URLSession.shared.data(for: request)
//            guard let httpResponse = response as? HTTPURLResponse,
//                httpResponse.statusCode == 200 else { return }
//            let image = UIImage(data: data)
//            await MainActor.run {
//                self.imageView.image = image
//            }
//        } catch {
//            print(error)
//        }
    }
}
