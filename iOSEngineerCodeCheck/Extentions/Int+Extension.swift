//
//  Int+Extension.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/24.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

extension Int {
    /// カンマ区切りの数字に変換する
    func decimal() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let decimalNumber = formatter.string(from: self as NSNumber) ?? ""
        return decimalNumber
    }
}
