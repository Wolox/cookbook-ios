//
//  FocusedCollectionViewCell.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 3/6/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class FocusedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var hexaLabel: UILabel!
    @IBOutlet weak var colorNameLabel: UILabel!
    @IBOutlet weak var coverView: UIView!
    
    var color: Color? {
        didSet {
            if let color = color {
                hexaLabel.text = color.hexaCode
                colorNameLabel.text = color.name
                coverView.backgroundColor = color.color
            }
        }
    }
    
    // This function updates the effects applied to the cell as it's rendering and moving up or down the screen
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let standardHeight = FocusedLayoutConstants.standardHeight
        let extendedHeight = FocusedLayoutConstants.extendedHeight
        
        // Delta indicates the percentage of the height change from the standard height to the extended height
        let delta = 1 - (extendedHeight - frame.height) / (extendedHeight - standardHeight)
        hexaLabel.alpha = delta
        hexaLabel.transform = CGAffineTransform(scaleX: delta, y: delta)
    }
}
