//
//  ApiError.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import Foundation

// MARK: - API通信のエラー類 -
enum ApiError: LocalizedError {
    case notFound // リクエストされたリソースが見つからなかった場合に返される。
    case invalidData // サーバーから受信したデータが正しく解析できない場合に返される。
    case serverError // サーバー側で何らかの問題が発生し、リクエストを処理できない場合に返される。
    case forbidden // リクエストされたアクションを実行するための権限がない場合に返される。
    case unknown // 上記のいずれにも該当しない、原因不明のエラーが発生した場合に返される。
    case cancel // タスクキャンセルされたら返す

    var errorDescription: String? {
        switch self {
        case .notFound: return "結果が見つかりませんでした"
        case .invalidData: return "データが正しく解析できませんでした。"
        case .serverError: return "サーバー側で何らかの問題が発生しました。"
        case .forbidden: return "検索上限に掛かりました時間をおいて再開してください。"
        case .unknown: return "原因不明のエラーが発生しました。"
        case .cancel: return "キャンセルされました。"
        }
    }
}
