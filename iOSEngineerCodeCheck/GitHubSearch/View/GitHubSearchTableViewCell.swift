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

    var avatarImage: UIImageView { avatarImageView }

    /// URLSessionで使用するタスク
    private var task: URLSessionDataTask? {
        didSet {
            // 以前のタスクがあればキャンセルします。
            oldValue?.cancel()
        }
    }

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

    func avatarImage(url: URL) {
        makeAvatarImage(url: url)
    }
}

private extension GitHubSearchTableViewCell {
    func setUp() {
        avatarImageView.layer.cornerRadius = 6

        fullNameLabel.adjustsFontSizeToFitWidth = true
        fullNameLabel.minimumScaleFactor = 0.7

        languageLabel.adjustsFontSizeToFitWidth = true
        languageLabel.minimumScaleFactor = 0.7

        starsLabel.adjustsFontSizeToFitWidth = true
        starsLabel.minimumScaleFactor = 0.7
    }
    /// アバターの写真を非同期処理で生成する。
    func makeAvatarImage(url: URL) {
        let configuration = URLSessionConfiguration.default
        // キャッシュがある場合は、キャッシュデータを使用し、それ以外の場合はネットワークからデータをロードする
        configuration.requestCachePolicy = .returnCacheDataElseLoad

        let session = URLSession(configuration: configuration)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        task = session.dataTask(with: request) { [weak self] data, response, error in
            // タスクがキャンセルされたらリターン
            if let error { return }

            guard let data, let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                return
            }

            let image = UIImage(data: data)
            DispatchQueue.main.async { [weak self] in
                self?.avatarImageView.image = image?.resize() // 画像のリサイズ
            }
        }
        task?.resume()
    }
}
