//
//  Repositories.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/20.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

struct ItemsRepository {
    var `default`: [Item]
    var asc: [Item]
    var desc: [Item]

    init() {
        self.`default` = []
        self.asc = []
        self.desc = []
    }

    var toDictionary: [Order: [Item]] {
        return [
                .default: `default`,
                .asc: asc,
                .desc: desc
        ]
    }

    mutating func allReset() {
        `default` = []
        asc = []
        desc = []
    }
}
