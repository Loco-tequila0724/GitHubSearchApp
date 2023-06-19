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
    func compress(byRatio compressionRatio: CGFloat = 0.2) -> UIImage {
        let size = CGSize(width: self.size.width * compressionRatio,
            height: self.size.height * compressionRatio)

        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }

    func image(color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        return UIGraphicsImageRenderer(size: size).image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.fill(CGRect(origin: .zero, size: size))
        }.resizableImage(withCapInsets: .zero)
    }
}
