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
    var desc: [Item]
    var asc: [Item]

    init() {
        self.`default` = []
        self.desc = []
        self.asc = []
    }

    var toDictionary: [Order: [Item]] {
        return [
                .default: `default`,
                .desc: desc,
                .asc: asc
        ]
    }

    mutating func allReset() {
        `default` = []
        desc = []
        asc = []
    }
}
