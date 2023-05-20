//
//  Repositories.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/20.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

struct RepositoryManager {
    var current: SearchRepositoryItem
    var `default`: DefaultRepository
    var desc: DescRepository
    var asc: AscRepository

    init(currentRepository: SearchRepositoryItem! = DefaultRepository()) {
        self.current = currentRepository
        self.`default` = DefaultRepository()
        self.desc = DescRepository()
        self.asc = AscRepository()
    }
}
