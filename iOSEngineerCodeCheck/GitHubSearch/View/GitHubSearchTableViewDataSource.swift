//
//  GitHubSearchTableViewDataSource.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/17.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

@MainActor
final class GitHubSearchTableViewDataSource: NSObject {
    typealias TableRow = GitHubSearchViewItem.TableRow

    private unowned let tableView: UITableView
    private var items: [TableRow] = []

    init(tableView: UITableView) {
        self.tableView = tableView
    }

    func reload(with items: [TableRow]) {
        self.items = items
        self.tableView.reloadData()
    }

    func replace(item: TableRow, at index: Int) {
        guard index < items.count, items[index].id == item.id else { return }
        items[index] = item
        let indexPath = IndexPath(row: index, section: 0)
        if let cell: GitHubSearchTableViewCell = tableView.cellForRow(at: indexPath) {
            cell.configure(item: item)
        }
    }
}

extension GitHubSearchTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell: GitHubSearchTableViewCell = tableView.dequeue(for: indexPath)
        cell.configure(item: item)
        return cell
    }
}
