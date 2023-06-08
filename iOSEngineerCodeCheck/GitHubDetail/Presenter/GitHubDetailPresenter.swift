//
//  GitHubDetailPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

final class GitHubDetailPresenter {
    weak var view: GitHubDetailView?
    private var router: GitHubDetailRouter!
    private let gitHubDetailViewItem: GitHubDetailViewItem!
    var item: Item!

    init(
        item: Item,
        view: GitHubDetailView? = nil,
        router: GitHubDetailRouter,
        gitHubDetailViewItem: GitHubDetailViewItem) {
        self.item = item
        self.view = view
        self.router = router
        self.gitHubDetailViewItem = gitHubDetailViewItem
    }
}

extension GitHubDetailPresenter: GitHubDetailPresentation {
    func viewDidLoad() {
        view?.configure(
            item: gitHubDetailViewItem,
            avatarUrl: item.owner.avatarUrl
        )
    }

    func safariButtoDidPush() {
        guard let url = URL(string: item.owner.htmlUrl) else { return }
        view?.showGitHubSite(url: url)
    }
}
