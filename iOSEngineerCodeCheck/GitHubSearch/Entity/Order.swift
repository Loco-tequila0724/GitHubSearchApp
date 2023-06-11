//
//  Order.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/20.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// MARK: - Star数ボタンに関する -
enum Order: String, CustomStringConvertible {
    case `default`
    case asc
    case desc

    var description: String {
        self.rawValue
    }
}
