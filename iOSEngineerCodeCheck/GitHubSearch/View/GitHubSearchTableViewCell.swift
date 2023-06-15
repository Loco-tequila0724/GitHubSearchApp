//
//  GitHubSearchTableViewCell.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

// VIPERアーキテクチャは適用していません。
final class GitHubSearchTableViewCell: UITableViewCell {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    /// テーブルビューセルのID名
    static let identifier = "GitHubSearchCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
}

extension GitHubSearchTableViewCell {
    /// 初期画面の構成
    func configure(item: GitHubSearchViewItem) {
        avatarImageView.setImageWithAnimation(item.avatarImageView)
        fullNameLabel.text = item.fullName
        languageLabel.text = item.language
        starsLabel.text = item.stars
    }
}

private extension GitHubSearchTableViewCell {
    func setUp() {
        avatarImageView.accessibilityIgnoresInvertColors = true
        avatarImageView.layer.cornerRadius = 6

        fullNameLabel.adjustsFontSizeToFitWidth = true
        fullNameLabel.minimumScaleFactor = 0.7

        languageLabel.adjustsFontSizeToFitWidth = true
        languageLabel.minimumScaleFactor = 0.7

        starsLabel.adjustsFontSizeToFitWidth = true
        starsLabel.minimumScaleFactor = 0.7
    }
}

private extension UIImageView {
    func setImageWithAnimation(_ image: UIImage?) {
        if self.image == nil {
            alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) { [weak self] in
                self?.alpha = 1
            }
        }
        self.image = image
    }
}
