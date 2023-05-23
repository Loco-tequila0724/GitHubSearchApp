//
//  GitHubSearchWireFrame.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/19.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

// Router
protocol GitHubSearchWireFrame: AnyObject {
    static func assembleModules() -> UIViewController
    func showGitHubDetailViewController(item: Item)
}
