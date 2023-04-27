import Foundation

enum ApiError: Error, LocalizedError {
    case notFound // リクエストされたリソースが見つからなかった場合に返される。
    case invalidData // サーバーから受信したデータが正しく解析できない場合に返される。
    case serverError // サーバー側で何らかの問題が発生し、リクエストを処理できない場合に返される。
    case unknown // 上記のいずれにも該当しない、原因不明のエラーが発生した場合に返される。

    var errorDescription: String? {
        switch self {
        case .notFound:
            return "結果が見つかりませんでした"
        case .invalidData:
            return "データが正しく解析できませんでした。"
        case .serverError:
            return "サーバー側で何らかの問題が発生しました。"
        case .unknown:
            return "原因不明のエラーが発生しました。"
        }
    }
}

// 今後使うかも。
// enum ApiError: Error {
// case networkError // ネットワーク接続に問題があるため、リクエストが失敗した場合に返される。
// case invalidResponse // サーバーから不正なレスポンスが返された場合に返されるエラーコードです。たとえば、予期しない形式のJSONデータが返された場合など。
// case unauthorized // 認証が必要なリクエストを実行する際に、認証されていない状態でリクエストを行った場合に返される。
// case forbidden // リクエストされたアクションを実行するための権限がない場合に返される。
// case notFound // リクエストされたリソースが見つからなかった場合に返される。
// case invalidData // サーバーから受信したデータが正しく解析できない場合に返される。
// case serverError // サーバー側で何らかの問題が発生し、リクエストを処理できない場合に返される。
// case timeout // リクエストがタイムアウトした場合に返されるエラーコードです。サーバー側が遅い場合や、ネットワーク接続が不安定な場合などで発生します。
// case unknown // 上記のいずれにも該当しない、原因不明のエラーが発生した場合に返される。
// }
