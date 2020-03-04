//
//  UIViewExtension.swift
//  Cookbook-ios
//
//  Created by Daniel Andres Charry on 04/03/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

extension UIView {
    
    func applyShadow(color: CGColor? = UIColor.shadow, size: CGSize? = CGSize(width: 1, height: 1), radius: CGFloat? = 4.0, opacity: Float? = 1.0) {
        self.layer.shadowColor = color
        self.layer.shadowOffset = size ?? CGSize(width: 1, height: 1)
        self.layer.shadowRadius = radius ?? 4.0
        self.layer.shadowOpacity = opacity ?? 1.0
        self.layer.masksToBounds = false
    }
}
