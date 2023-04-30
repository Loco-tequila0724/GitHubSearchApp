import UIKit

// VIPERアーキテクチャは適用していません。
final class GitHubSearchTableViewCell: UITableViewCell {
    @IBOutlet private weak var gitHubImageView: UIImageView! {
        didSet {
            gitHubImageView.layer.cornerRadius = 6
        }
    }
    @IBOutlet private weak var fullNameLabel: UILabel! {
        didSet {
            fullNameLabel.adjustsFontSizeToFitWidth = true
            fullNameLabel.minimumScaleFactor = 0.7
        }
    }
    @IBOutlet private weak var languageLabel: UILabel! {
        didSet {
            languageLabel.adjustsFontSizeToFitWidth = true
            languageLabel.minimumScaleFactor = 0.7
        }
    }
    @IBOutlet private weak var starsLabel: UILabel! {
        didSet {
            starsLabel.adjustsFontSizeToFitWidth = true
            starsLabel.minimumScaleFactor = 0.7
        }
    }
    /// テーブルビューセルのID名
    static let identifier = "GitHubSearchCell"

    var gitHubImage: UIImageView { gitHubImageView }

    /// URLSessionで使用するタスク
    private var task: URLSessionDataTask? {
        didSet {
            // 以前のタスクがあればキャンセルします。
            oldValue?.cancel()
        }
    }
}

extension GitHubSearchTableViewCell {
    /// 初期画面の構成
    func configure(fullName: String, language: String, stars: String) {
        fullNameLabel.text = fullName
        languageLabel.text = language
        starsLabel.text = stars
    }

    func gitHubImage(url: URL) {
        makeUserAvatarImage(url: url)
    }
}

private extension GitHubSearchTableViewCell {
    /// アバターの写真を非同期処理で生成する。
    func makeUserAvatarImage(url: URL) {
        // キャッシュを有効にするためのURLSessionConfiguration オブジェクトを作成
        let configuration = URLSessionConfiguration.default
        // キャッシュがある場合は、キャッシュデータを使用し、それ以外の場合はネットワークからデータをロードする
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        //  キャッシュを有効にした URLSession オブジェクトを作成
        let session = URLSession(configuration: configuration)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        task = session.dataTask(with: request) { [weak self] data, response, error in
            // タスクがキャンセルされたらリターン
            if let error { Debug.log(errorDescription: error.localizedDescription)
                return
            }

            guard let data, let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                return
            }

            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self?.gitHubImageView.image = image

            }
        }
        task?.resume()
    }
}
