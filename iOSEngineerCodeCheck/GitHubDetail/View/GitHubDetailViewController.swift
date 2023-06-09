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
    @IBOutlet private weak var fullNameLabel: UILabel!
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

    func inject(presenter: GitHubDetailPresenter) {
        self.presenter = presenter
    }
}

extension GitHubDetailViewController: GitHubDetailView {
    /// 初期画面の構成
    func configure(item: GitHubDetailViewItem, avatarUrl: URL) {
        setupNavigationBar(
            title: "リポジトリ",
            buttonImage: UIImage(systemName: "safari")!,
            rightBarButtonAction: #selector(safari(_:))
        )

        imageView.loadImageAsynchronous(url: avatarUrl)
        fullNameLabel.text = item.fullName
        languageLabel.text = item.language
        starsLabel.text = item.stars
        watchersLabel.text = item.watchers
        forksLabel.text = item.forks
        issuesLabel.text = item.issues
    }

    @objc func safari (_ sender: UIBarButtonItem) {
        presenter.safariButtoDidPush()
    }
}

extension GitHubDetailViewController {
    func showGitHubSite(url: URL) {
        UIApplication.shared.open(url)
    }
}
