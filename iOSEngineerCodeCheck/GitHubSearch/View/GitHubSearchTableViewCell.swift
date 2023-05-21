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
    @IBOutlet private weak var avatarImageView: AvatarImageView!
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
    func configure(fullName: String, language: String, stars: String) {
        fullNameLabel.text = fullName
        languageLabel.text = language
        starsLabel.text = stars
    }
    // アバター画像の生成
    func setAvatarImage(url: URL) {
        avatarImageView.load(url: url)
    }
}

private extension GitHubSearchTableViewCell {
    func setUp() {
        fullNameLabel.adjustsFontSizeToFitWidth = true
        fullNameLabel.minimumScaleFactor = 0.7

        languageLabel.adjustsFontSizeToFitWidth = true
        languageLabel.minimumScaleFactor = 0.7

        starsLabel.adjustsFontSizeToFitWidth = true
        starsLabel.minimumScaleFactor = 0.7
    }
}
