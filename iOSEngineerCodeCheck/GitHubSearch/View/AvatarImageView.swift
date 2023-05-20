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

    func load(url: URL?) async {
        do {
            imageLoader.cancel()
            let image = try await imageLoader.load(url: url)
            DispatchQueue.main.async { [weak self] in
                self?.image = image.resize()
            }
        } catch {
            DispatchQueue.main.async { [weak self] in
                self?.image = UIImage(named: "Untitled")
            }
        }
    }
}
