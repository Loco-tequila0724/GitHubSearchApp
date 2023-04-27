import UIKit

extension UIImageView {
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
