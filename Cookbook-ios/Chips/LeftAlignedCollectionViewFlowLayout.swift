//
//  LeftAlignedCollectionViewFlowLayout.swift
//  Cookbook-ios
//
//  Created by Matías Spinelli on 24/02/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    let leftPadding: CGFloat = 20.0
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin: CGFloat = leftPadding
        var maxY: CGFloat = 0.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementKind != UICollectionView.elementKindSectionHeader {
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = leftPadding
                }
                
                layoutAttribute.frame.origin.x = leftMargin
                
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        return attributes
    }
}
