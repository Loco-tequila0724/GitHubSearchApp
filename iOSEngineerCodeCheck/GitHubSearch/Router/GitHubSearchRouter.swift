//
//  GitHubSearchRouter.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

final class GitHubSearchRouter {
    private weak var viewController: UIViewController?

    private init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}

extension GitHubSearchRouter: GitHubSearchWireFrame {
    static func assembleModules() -> UIViewController {
        let view = GitHubSearchViewController.instantiate()
        let interactor = GitHubSearchInteractor()
        let router = GitHubSearchRouter(viewController: view)
        let presenter = GitHubSearchPresenter(
            view: view,
            interactor: interactor,
            router: router)

        view.inject(presenter: presenter)
        interactor.inject(presenter: presenter)
        return view
    }

    func showGitHubDetailViewController(item: Item) {
        // GitHubのデータはここで持たせて次の画面に渡します。
        let gitHubDetailRouterViewController = GitHubDetailRouter.assembleModules(item: item)
        viewController?.navigationController?.pushViewController(gitHubDetailRouterViewController, animated: true)
    }
}
