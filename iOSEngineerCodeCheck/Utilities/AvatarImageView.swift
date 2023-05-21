//
//  AvatarImageView.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/05/21.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

final class AvatarImageView: UIImageView {
    private let imageLoader = ImageLoader()

    override func awakeFromNib() {
        super.awakeFromNib()
        accessibilityIgnoresInvertColors = true
        layer.cornerRadius = 6
    }
}

extension AvatarImageView {
    /// 取得した画像をUIimageViewにセット
    func setUp(url: URL?) async {
        do {
            image = nil
            let image = try await imageLoader.load(url: url)

            DispatchQueue.main.async { [weak self] in
                self?.image = image.resize()
            }
        } catch let error {
            // タスク(画像の取得処理)がキャンセルされたらリターン
            guard error as? TaskError != TaskError.cancel else { return }

            // もし画像の取得がエラーだった場合、ダミーの画像を表示。
            DispatchQueue.main.async { [weak self] in
                self?.image = UIImage(named: "Untitled")
            }
        }
    }
}
