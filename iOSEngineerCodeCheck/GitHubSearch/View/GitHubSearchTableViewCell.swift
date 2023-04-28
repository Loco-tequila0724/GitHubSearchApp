import UIKit
// TODO: - オートレイアウト未 -
final class GitHubSearchTableViewCell: UITableViewCell {
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var gitHubImageView: UIImageView!
    // テーブルビューセルのID名
    static let identifier = "GitHubSearchCell"
    
    var gitHubImage: UIImageView { gitHubImageView }

    func configure(fullName: String, language: String) {
        fullNameLabel.text = fullName
        languageLabel.text = language
    }
}
