//
//  Repositories.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/20.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

struct RepositoryManager {
    var currentRepository: RepositoryItem
    var defaultRepository: DefaultRepository
    var descRepository: DescRepository
    var ascRepository: AscRepository

    init(currentRepository: RepositoryItem! = DefaultRepository()) {
        self.currentRepository = currentRepository
        self.defaultRepository = DefaultRepository()
        self.descRepository = DescRepository()
        self.ascRepository = AscRepository()
    }
}
