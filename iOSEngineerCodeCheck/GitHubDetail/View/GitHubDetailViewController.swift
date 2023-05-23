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
}

extension GitHubDetailViewController: GitHubDetailView {
    /// 初期画面の構成
    func configure(item: Item?) {
        setupNavigationBar(
            title: "リポジトリ",
            buttonImage: UIImage(systemName: "safari")!,
            rightBarButtonAction: #selector(safari(_:))
        )

        guard let item else { return }
        imageView.loadImageAsynchronous(url: item.owner.avatarUrl)
        fullNameLabel.text = item.fullName
        languageLabel.text = "言語 \(item.language ?? "")"
        starsLabel.text = "\(String(item.stargazersCount))"
        watchersLabel.text = "\(String(item.watchersCount))"
        forksLabel.text = "\(String(item.forksCount))"
        issuesLabel.text = "\(String(item.openIssuesCount))"
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
