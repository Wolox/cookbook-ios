//
//  FocusedCollectionViewCell.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 3/6/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class FocusedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var coverView: UIView!
    
    var color: Color? {
        didSet {
            if let color = color {
                nameLabel.text = color.name
                descriptionLabel.text = color.description
                coverView.backgroundColor = color.color
            }
        }
    }
    
    // This function updates the effects applied to the cell as it's rendering and moving up or down the screen
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let standardHeight = FocusedLayoutConstants.standardHeight
        let featuredHeight = FocusedLayoutConstants.featuredHeight
        
        // Delta indicates the percentage of the height change from the standard height to the featured height
        let delta = 1 - (featuredHeight - frame.height) / (featuredHeight - standardHeight)
        let scale = max(delta, 0.5)
        nameLabel.alpha = delta
        nameLabel.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
