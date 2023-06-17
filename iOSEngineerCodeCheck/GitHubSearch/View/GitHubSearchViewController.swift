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
    @IBOutlet private weak var emptyDescriptionLabel: UILabel!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var starOderButton: UIButton!

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

    func inject(presenter: GitHubSearchPresenter) {
        self.presenter = presenter
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
    func setUp() {
        searchBar.placeholder = "GitHub リポジトリを検索"
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        emptyDescriptionLabel.text = nil
        indicatorView.isHidden = true
        setupNavigationBar(title: "ホーム")
    }
    /// 画像の取得が完了したらこのセルだけ更新する。
    func configure(item: GitHubSearchViewItem.TableRow, at index: Int) {
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GitHubSearchTableViewCell {
            cell.configure(item: item)
        }
    }

    /// 画面の状態をリセットする
    func resetDisplay() {
        DispatchQueue.main.async { [self] in
            isLoading = false
            indicatorView.isHidden = true
            emptyDescriptionLabel.text = nil
            tableView.reloadData()
        }
    }

    /// ローディング中を表示
    func startLoading() {
        DispatchQueue.main.async { [self] in
            indicatorView.isHidden = false
            indicatorView.startAnimating()
            tableView.reloadData()
        }
    }

    /// ローディング画面を停止
    func stopLoading() {
        DispatchQueue.main.async { [self] in
            isLoading = false
            indicatorView.stopAnimating()
            indicatorView.isHidden = true
        }
    }

    /// エラーアラートの表示
    func appearErrorAlert(message: String) {
        errorAlert(message: message)
    }

    /// GitHubデータの取得が0件の場合に表示
    func appearNotFound(message: String) {
        DispatchQueue.main.async { [self] in
            indicatorView.isHidden = true
            emptyDescriptionLabel.text = message
        }
    }

    func tableViewReload() {
        DispatchQueue.main.async { [self] in
            tableView.reloadData()
        }
    }

    /// ボタンの見た目を変更する
    func didChangeStarOrder(order: StarSortingOrder) {
        starOderButton.setTitle(order.text, for: .normal)
        starOderButton.backgroundColor = order.backGroundColor
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GitHubSearchTableViewCell.identifier, for: indexPath) as? GitHubSearchTableViewCell else { return UITableViewCell() } // swiftlint:disable:this all
        cell.selectionStyle = .none

        let item = presenter.item(at: indexPath.row)

        cell.configure(item: item)
        return cell
    }

    /// UITableViewのセルが表示される直前に呼び出される。
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayRow(at: indexPath.row)
    }
}

extension GitHubSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルタップを通知。GitHubデータを渡してます。
        presenter.didSelectRow(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = 85
        return cellHeight
    }
}

private extension StarSortingOrder {
    var text: String {
        switch self {
        case .`default`: return "デフォルト"
        case .desc: return "☆ Star数 ⍋"
        case .asc: return "☆ Star数 ⍒"
        }
    }

    var backGroundColor: UIColor {
        switch self {
        case .`default`: return .lightGray
        case .desc: return UIColor(named: "StarSortColor")!
        case .asc: return UIColor(named: "StarSortColor")!
        }
    }
}
