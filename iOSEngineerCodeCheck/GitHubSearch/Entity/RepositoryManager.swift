//
//  Repositories.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/20.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

struct RepositoryManager {
    var current: SearchItem
    var `default`: DefaultSearchItem
    var desc: DescSearchItem
    var asc: AscSearchItem

    init(currentSearchItem: SearchItem = DefaultSearchItem()) {
        self.current = currentSearchItem
        self.`default` = DefaultSearchItem()
        self.desc = DescSearchItem()
        self.asc = AscSearchItem()
    }
}
