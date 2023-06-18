//
//  UIButton+Extension.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/18.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import class UIKit.UIButton
import class UIKit.UIImage

extension UIButton {
    func setBackgroundImage(_ image: UIImage?) {
        setBackgroundImage(image, for: .normal)
        setBackgroundImage(image, for: .highlighted)
        setBackgroundImage(image, for: .selected)
        setBackgroundImage(image, for: [.selected, .highlighted])
    }
}
