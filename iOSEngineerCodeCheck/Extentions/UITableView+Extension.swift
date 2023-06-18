//
//  UITableView+Extension.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/18.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeue<Cell: UITableViewCell>(_ cell: Cell.Type = Cell.self, with identifier: String? = nil, for indexPath: IndexPath) -> Cell {
        let identifier = identifier ?? String(describing: Cell.self)
        let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell
        return cell ?? {
            fatalError("\(Cell.self) not registered.")
        }()
    }

    func cellForRow<Cell: UITableViewCell>(at indexPath: IndexPath, _ type: Cell.Type = Cell.self) -> Cell? {
        cellForRow(at: indexPath) as? Cell
    }
}
