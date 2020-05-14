//
//  UIButtonExtension.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 3/30/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

extension UIButton {
    func setTitle(title: String, image: UIImage) {
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        imageView!.contentMode = .scaleAspectFit
        imageView!.clipsToBounds = true

        //TODO: fix this
        let imageWidth = frame.width / 4.0
        self.imageEdgeInsets = UIEdgeInsets(top: 10, left: -imageWidth, bottom: 10, right: -imageWidth);
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWidth * 3), bottom: 0, right: 0);

        layoutIfNeeded()
    }
    
    func setCookBookStyle(withColor color: UIColor) {
        backgroundColor = color
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        titleLabel?.textAlignment = .center
        layer.cornerRadius = 15
        setTitleColor(.white, for: .normal)
    }
}
