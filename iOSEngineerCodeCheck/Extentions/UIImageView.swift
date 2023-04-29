import UIKit

// MARK: - 画像の取得を非同期的に行なう -
extension UIImageView {
    /// 画像の読み込みを非同期で行なう。
    func loadImageAsynchronous(url: URL?) {
        guard let url else { return }
        Task.detached {
            let imageData: Data? = try Data(contentsOf: url)
            guard let imageData else { return }
            await MainActor.run {
                self.image = UIImage(data: imageData)
            }
        }
    }
}
