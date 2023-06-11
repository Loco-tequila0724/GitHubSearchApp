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
    /// ※命名は一例(ref: https://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q1121162786)
    func to1000SeparatedString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let decimalNumber = formatter.string(from: self as NSNumber) ?? ""
        return decimalNumber
    }
}
