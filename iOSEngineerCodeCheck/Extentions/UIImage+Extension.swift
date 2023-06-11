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
}
