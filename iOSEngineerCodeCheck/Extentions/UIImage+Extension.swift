//
//  UIImage+Extension.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/04/25.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit.UIImage

extension UIImage {
    /// 画像サイズを圧縮
    func resize() -> UIImage {
        let size = CGSize(width: self.size.width * 0.2, height: self.size.height * 0.2)

        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
