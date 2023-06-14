//
//  ItemID.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/15.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

struct ItemID: Identifiable, Hashable {
    let id: Int
}

extension ItemID: RawRepresentable {
    var rawValue: Int {
        id
    }

    init(rawValue: Int) {
        self.init(id: rawValue)
    }
}

extension ItemID: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(Int.self)
        self.init(rawValue: value)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}
