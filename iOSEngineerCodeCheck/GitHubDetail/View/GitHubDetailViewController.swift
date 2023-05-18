//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

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
    @IBOutlet private weak var watchersLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var issuesLabel: UILabel!

    private static let storyboardID = "GitHubDetailID"
    private static let storyboardName = "GitHubDetail"

    var presenter: GitHubDetailPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
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
    /// 初期画面の構成
    func configure() {
        setupNavigationBar(title: "リポジトリ")
        guard let item = presenter.item else { return }
        let imageURL = item.owner.avatarUrl
        imageView.loadImageAsynchronous(url: imageURL)
        titleLabel.text = item.fullName
        languageLabel.text = "言語 \(item.language ?? "")"
        starsLabel.text    = "\(String(item.stargazersCount))"
        watchersLabel.text = "\(String(item.watchersCount))"
        forksLabel.text    = "\(String(item.forksCount))"
        issuesLabel.text   = "\(String(item.openIssuesCount))"
    }
}
