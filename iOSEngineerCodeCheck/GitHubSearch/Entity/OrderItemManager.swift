//
//  Repositories.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/20.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

struct OrderItemManager {
    var current: OrderSearchItem
    var `default`: DefaultOrderSearchItem
    var desc: DescOrderSearchItem
    var asc: AscOrderSearchItem

    init(currentOrderSearchItem: OrderSearchItem = DefaultOrderSearchItem()) {
        self.current = currentOrderSearchItem
        self.`default` = DefaultOrderSearchItem()
        self.desc = DescOrderSearchItem()
        self.asc = AscOrderSearchItem()
    }
}
