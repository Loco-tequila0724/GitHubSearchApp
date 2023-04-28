import UIKit

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
    /// 画像の読み込みを非同期で行い、画像をサイズ。
    func loadResizeImageAsynchronous(url: URL?) {
        guard let url else { return }
        Task.detached {
            let imageData: Data? = try Data(contentsOf: url)
            guard let imageData else { return }
            await MainActor.run {
                let image = UIImage(data: imageData)
                self.image = image?.resize()
            }
        }
    }
}
