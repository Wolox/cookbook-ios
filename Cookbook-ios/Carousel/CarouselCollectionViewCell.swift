//
//  CarouselCollectionViewCell.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 12/24/19.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = .cardsBackground
            containerView.layer.cornerRadius = 25
        }
    }
    @IBOutlet weak var featureTitle: UILabel!
    @IBOutlet weak var featureImage: UIImageView!
    
    func configureCellWith(title: String, image: UIImage) {
        featureTitle.text = title
        featureImage.image = image
    }
}
