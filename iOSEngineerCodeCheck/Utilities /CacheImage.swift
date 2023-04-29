import UIKit

// MARK: - 画像のキャッシュ生成で使用する -
final class ImageProvider {
    static let shared = ImageProvider()
    private let cache = NSCache<NSString, UIImage>()
    private init () { }

    ///  画像のキャッシュ生成を行い返す。
    func createPhotoImage(url: URL?) async -> UIImage? {
        //  すでにキャッシュした画像があればキャッシュ画像を返す
        if let photoURL = url?.absoluteString, let cacheImage = cache.object(forKey: photoURL as NSString) {
            return cacheImage
        } else {
            guard let url else { return nil }
            //  画像のキャッシュがない場合は、セットを行なう。
            do {
                let data = try Data(contentsOf: url)
                async let image = UIImage(data: data) ?? nil
                // キャッシュに保持する
                await cache.setObject(image?.resize() ?? UIImage(), forKey: url.absoluteString as NSString)
                return await image?.resize()
            } catch {
                return nil
            }
        }
    }
}
