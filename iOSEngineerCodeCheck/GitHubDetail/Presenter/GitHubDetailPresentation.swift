//
//  GitHubDetailPresentation.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/19.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// Presentation
protocol GitHubDetailPresentation: AnyObject {
    var view: GitHubDetailView? { get }
    var router: GitHubDetailRouter? { get }
    var item: Item? { get }
    func viewDidLoad()
}
