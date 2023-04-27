import UIKit

final class GitHubSearchTableViewCell: UITableViewCell {
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    // テーブルビューセルのID名
    static let identifier = "GitHubSearchCell"

    func configure(fullName: String, language: String) {
        fullNameLabel.text = fullName
        languageLabel.text = language
    }
}
