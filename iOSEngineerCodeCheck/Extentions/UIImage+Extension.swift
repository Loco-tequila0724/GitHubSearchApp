import UIKit

extension UIImage {
    //    リサイズ、画像サイズを圧縮できる
    func resize() -> UIImage {
        let size = CGSize(width: self.size.width * 0.2, height: self.size.height * 0.2)

        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }

    // 画像容量の取得 (KB)
    func checkImageData() {
        let imageData = NSData(data: self.jpegData(compressionQuality: 1)!).count
        print("🐕", Double(imageData) / 1000.0, "KB")
    }
}

