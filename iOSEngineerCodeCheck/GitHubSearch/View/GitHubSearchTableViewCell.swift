import UIKit

final class GitHubSearchTableViewCell: UITableViewCell {
    @IBOutlet private weak var gitHubImageView: UIImageView! {
        didSet {
            gitHubImageView.layer.cornerRadius = 6
        }
    }
    @IBOutlet private weak var fullNameLabel: UILabel! {
        didSet {
            fullNameLabel.adjustsFontSizeToFitWidth = true
            fullNameLabel.minimumScaleFactor = 0.7
        }
    }
    @IBOutlet private weak var languageLabel: UILabel! {
        didSet {
            languageLabel.adjustsFontSizeToFitWidth = true
            languageLabel.minimumScaleFactor = 0.7
        }
    }
    @IBOutlet private weak var starsLabel: UILabel! {
        didSet {
            starsLabel.adjustsFontSizeToFitWidth = true
            starsLabel.minimumScaleFactor = 0.7
        }
    }
    // テーブルビューセルのID名
    static let identifier = "GitHubSearchCell"
    var gitHubImage: UIImageView { gitHubImageView }
}

extension GitHubSearchTableViewCell {
    /// 初期画面の構成
    func configure(fullName: String, language: String, stars: String) {
        fullNameLabel.text = fullName
        languageLabel.text = language
        starsLabel.text = stars
    }

    func gitHubImage(image: UIImage) {
        gitHubImageView.image = image
    }
}
