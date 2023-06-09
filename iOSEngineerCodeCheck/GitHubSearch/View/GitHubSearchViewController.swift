//
//  ViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class GitHubSearchViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var notFoundLabel: UILabel!
    @IBOutlet private weak var frontView: UIView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var starOderButton: UIButton! {
        didSet {
            if #available(iOS 15.0, *) {
                starOderButton.configuration = nil
            }
            starOderButton.setTitle("☆ Star数 ", for: .normal)
            starOderButton.titleLabel?.font = .systemFont(
                ofSize: 16,
                weight: .semibold
            )
            starOderButton.layer.cornerRadius = 8
            starOderButton.clipsToBounds = true
            starOderButton.titleLabel?.adjustsFontSizeToFitWidth = true
        }
    }

    private static let storyboardID = "GitHubSearchID"
    private static let storyboardName = "Main"

    var presenter: GitHubSearchPresentation!
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}

extension GitHubSearchViewController {
    static func instantiate() -> GitHubSearchViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let view = storyboard.instantiateViewController(withIdentifier: storyboardID) as? GitHubSearchViewController
        return view ?? GitHubSearchViewController()
    }
}

private extension GitHubSearchViewController {
    @IBAction func starOrderButton(_ sender: Any) {
        guard !isLoading else { return }
        presenter.starOderButtonDidPush()
    }
}

// MARK: - GitHubSearchViewプロトコルに関する -
extension GitHubSearchViewController: GitHubSearchView {
    /// 初期画面の構成
    func configure() {
        searchBar.placeholder = "GitHub リポジトリを検索"
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        notFoundLabel.text = nil
        frontView.isHidden = true
        setupNavigationBar(title: "ホーム")
    }

    /// 画面の状態をリセットする
    func resetDisplay() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.frontView.isHidden = true
            self?.indicatorView.isHidden = true
            self?.notFoundLabel.text = nil
            self?.tableView.reloadData()
        }
    }

    /// ローディング中を表示
    func startLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
            self?.indicatorView.startAnimating()
            self?.frontView.isHidden = false
            self?.indicatorView.isHidden = false
        }
    }

    /// ローディング画面を停止
    func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.indicatorView.stopAnimating()
            self?.frontView.isHidden = true
            self?.indicatorView.isHidden = true
        }
    }

    /// エラーアラートの表示
    func appearErrorAlert(message: String) {
        errorAlert(message: message)
    }

    /// GitHubデータの取得が0件の場合に表示
    func appearNotFound(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.frontView.isHidden = false
            self?.indicatorView.isHidden = true
            self?.notFoundLabel.text = message
        }
    }

    func tableViewReload() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    func reloadRow(at index: Int) {
        tableView.performBatchUpdates {
            guard index < tableView.numberOfRows(inSection: 0) else {
                return
            }
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }

    /// ボタンの見た目を変更する
    func didChangeStarOrder(searchItem: [Item], order: Order) {
        starOderButton.setTitle(order.text, for: .normal)
        starOderButton.backgroundColor = order.backgroundColor
    }
}

private extension Order {
    var text: String {
        switch self {
        case .default:
            return "☆ Star数 "
        case .asc:
            return "☆ Star数 ⍒"
        case .desc:
            return "☆ Star数 ⍋"
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .default:
            return .lightGray
        case .asc:
            return #colorLiteral(red: 0.1634489, green: 0.1312818527, blue: 0.2882181406, alpha: 1)
        case .desc:
            return #colorLiteral(red: 0.1634489, green: 0.1312818527, blue: 0.2882181406, alpha: 1)
        }
    }
}

// MARK: - サーチボタンに関する -
extension GitHubSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let isEmptyText = searchBar.text?.isEmpty else { return }
        if isEmptyText {
            // テキストが空になった事を通知。テーブルビューをリセットするため。
            presenter.searchTextDidChange()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // テキストが空、もしくはローディング中はタップ無効。
        guard let text = searchBar.text, !text.isEmpty, !isLoading else { return }
        // 検索ボタンのタップを通知。 GitHubデータを取得の指示。
        presenter.searchButtonDidPush(word: text)
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }

    // キャンセルボタンを表示
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    // キャンセルボタンとキーボードを非表示。
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension GitHubSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRow
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GitHubSearchTableViewCell.identifier) as? GitHubSearchTableViewCell else { return UITableViewCell() } // swiftlint:disable:this all
        cell.selectionStyle = .none

        let item = presenter.item(at: indexPath.row)

        cell.configure(item: item)
        return cell
    }
}

extension GitHubSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルタップを通知。GitHubデータを渡してます。
        presenter.didSelectRow(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}
