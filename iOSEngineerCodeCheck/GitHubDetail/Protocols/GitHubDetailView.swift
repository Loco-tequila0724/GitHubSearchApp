//
//  GitHubDetailView.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/19.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

// View
protocol GitHubDetailView: AnyObject {
    var presenter: GitHubDetailPresenter! { get }
    func configure(item: GitHubDetailViewItem)
    func showGitHubSite(url: URL)
    func setAvatarImage(image: UIImage)
}
