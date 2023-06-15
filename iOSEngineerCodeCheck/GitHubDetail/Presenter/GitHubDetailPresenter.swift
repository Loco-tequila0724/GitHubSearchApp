//
//  GitHubDetailPresenter.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation
import class UIKit.UIImage

final class GitHubDetailPresenter {
    weak var view: GitHubDetailView?
    private let router: GitHubDetailRouter!
    private let gitHubDetailViewItem: GitHubDetailViewItem!
    var item: Item!

    init(
        item: Item,
        view: GitHubDetailView,
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
        view?.configure(item: gitHubDetailViewItem)

        Task { @MainActor in
            let image = await makeAvatarImage(url: item.owner.avatarUrl)
            view?.setAvatarImage(image: image)
        }
    }

    func safariButtoDidPush() {
        guard let url = URL(string: item.owner.htmlUrl) else { return }
        view?.showGitHubSite(url: url)
    }
}

private extension GitHubDetailPresenter {
    func makeAvatarImage(url: URL) async -> UIImage {
        do {
            let imageData: Data? = try Data(contentsOf: url)
            guard let imageData else { return UIImage(named: "Untitled")! }
            let image = UIImage(data: imageData)!
            return image
        } catch {
            return UIImage(named: "Untitled")!
        }
    }
}
