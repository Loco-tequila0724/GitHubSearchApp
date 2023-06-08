//
//  GitHubDetailView.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/19.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// View
protocol GitHubDetailView: AnyObject {
    var presenter: GitHubDetailPresenter! { get }
    func configure(item: GitHubDetailViewItem, avatarUrl: URL)
    func showGitHubSite(url: URL)
}
