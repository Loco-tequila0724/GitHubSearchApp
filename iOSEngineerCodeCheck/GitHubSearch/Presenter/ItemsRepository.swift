//
//  Repositories.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/20.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

struct ItemsRepository {
    var current: [Item]
    var `default`: [Item]
    var desc: [Item]
    var asc: [Item]

    init() {
        self.current = []
        self.`default` = []
        self.desc = []
        self.asc = []
    }

    mutating func allReset() {
        current = []
        `default` = []
        desc = []
        asc = []
    }
}
