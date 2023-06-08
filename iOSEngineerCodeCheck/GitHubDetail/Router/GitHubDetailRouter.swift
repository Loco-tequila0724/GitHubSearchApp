//
//  GitHubDetailRouter.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

final class GitHubDetailRouter {
    private weak var viewController: UIViewController?

    private init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}

extension GitHubDetailRouter: GitHubDetailWireFrame {
    static func assembleModules(item: Item) -> UIViewController {
        let view = GitHubDetailViewController.instantiate()
        let router = GitHubDetailRouter(viewController: view)
        let gitHubDetailViewItem = GitHubDetailViewItem(item: item)
        let presenter = GitHubDetailPresenter(
            item: item,
            view: view,
            router: router,
            gitHubDetailViewItem: gitHubDetailViewItem
        )

        view.presenter = presenter

        return view
    }
}
