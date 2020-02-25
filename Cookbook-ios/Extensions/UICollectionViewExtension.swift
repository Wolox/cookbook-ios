//
//  UICollectionViewExtension.swift
//  Cookbook-ios
//
//  Created by Matías Spinelli on 24/02/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func textSize(text: String, font: UIFont) -> CGSize {
        let textPadding: CGFloat = 15.0
        let viewBounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.width-(textPadding*2), height: self.bounds.height)
        
        let label: UILabel = {
            let _label = UILabel()
            _label.numberOfLines = 0
            _label.text = text
            _label.font = font
            _label.lineBreakMode = .byTruncatingTail
            return _label
        }()
        
        var sizeThatFits = label.sizeThatFits(viewBounds.size)
        sizeThatFits.height = 24
        sizeThatFits.width += textPadding
        return sizeThatFits
    }
}
