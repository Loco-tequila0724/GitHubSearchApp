//
//  UIActivityIndicatorView.swift
//  iOSEngineerCodeCheck
//
//  Created by 日高隼人 on 2023/06/18.
//  Copyright © 2023 YUMEMI Inc. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    func setIsAnimating(_ isAnimating: Bool) {
        if isAnimating {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
}
