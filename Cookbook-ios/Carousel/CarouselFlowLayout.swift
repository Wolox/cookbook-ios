//
//  CarouselFlowLayout.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 1/21/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

// https://stackoverflow.com/questions/39390979/how-to-make-the-center-cell-of-the-uicollectionview-overlap-the-other-two-cells

import UIKit

class CarouselFlowLayout: UICollectionViewFlowLayout {
    private struct LayoutState {
        var size: CGSize
        var direction: UICollectionView.ScrollDirection
        func isEqual(otherState: LayoutState) -> Bool {
            return size.equalTo(otherState.size) && direction == otherState.direction
        }
    }
    private let sideItemScale: CGFloat
    private let sideItemAlpha: CGFloat
    private let sideSpacing: CGFloat
    private var state = LayoutState(size: .zero, direction: .horizontal)
    
    /**
     Creates a Collectiion view flow layout that handles cells presentation
     
     - Parameter sideItemScale: Scale percentage for the size of the side cells
     - Parameter sideItemAlpha: Alpha for the side cells
     - Parameter sideSpacing: Distance between cells
     
     */
    init(sideItemScale: CGFloat, sideItemAlpha: CGFloat, sideSpacing: CGFloat) {
        self.sideItemScale = sideItemScale
        self.sideItemAlpha = sideItemAlpha
        self.sideSpacing = sideSpacing
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let currentState = LayoutState(size: collectionView.bounds.size, direction: scrollDirection)
        if !state.isEqual(otherState: currentState) {
            setupCollectionViewDecelerationRate()
            updateLayout()
            state = currentState
        }
    }
}

// MARK: - Override UICollectionViewFlowLayout functions
extension CarouselFlowLayout {
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let superAttributes = super.layoutAttributesForElements(in: rect),
            let attributes = NSArray(array: superAttributes, copyItems: true) as? [UICollectionViewLayoutAttributes]
            else { return nil }
        return attributes.map({ self.transformLayoutAttributes(attributes: $0) })
    }
    
    override public func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView, !collectionView.isPagingEnabled,
            let layoutAttributes = self.layoutAttributesForElements(in: collectionView.bounds)
            else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        
        let isHorizontal = self.scrollDirection == .horizontal
        
        let midSide = (isHorizontal ? collectionView.bounds.size.width : collectionView.bounds.size.height) / 2
        let proposedContentOffsetCenterOrigin = (isHorizontal ? proposedContentOffset.x : proposedContentOffset.y) + midSide
        
        var targetContentOffset: CGPoint
        if isHorizontal {
            let closest = layoutAttributes.sorted { abs($0.center.x - proposedContentOffsetCenterOrigin) < abs($1.center.x - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: floor(closest.center.x - midSide), y: proposedContentOffset.y)
        }
        else {
            let closest = layoutAttributes.sorted { abs($0.center.y - proposedContentOffsetCenterOrigin) < abs($1.center.y - proposedContentOffsetCenterOrigin) }.first ?? UICollectionViewLayoutAttributes()
            targetContentOffset = CGPoint(x: proposedContentOffset.x, y: floor(closest.center.y - midSide))
        }
        
        return targetContentOffset
    }
}

// MARK: - Helper methods
private extension CarouselFlowLayout {
    func setupCollectionViewDecelerationRate() {
        guard let collectionView = collectionView else { return }
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    func updateLayout() {
        guard let collectionView = collectionView else { return }
        let collectionSize = collectionView.bounds.size
        let isHorizontal = (scrollDirection == .horizontal)
        
        let yInset = (collectionSize.height - itemSize.height) / 2
        let xInset = (collectionSize.width - itemSize.width) / 2
        sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        
        let side = isHorizontal ? itemSize.width : itemSize.height
        let scaledItemOffset = (side - side * sideItemScale) / 2
        minimumLineSpacing = sideSpacing - scaledItemOffset
    }
    
    func transformLayoutAttributes(attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let collectionView = self.collectionView else { return attributes }
        let isHorizontal = self.scrollDirection == .horizontal
        
        let collectionCenter = isHorizontal ? (collectionView.frame.size.width / 2) : (collectionView.frame.size.height / 2)
        let offset = isHorizontal ? collectionView.contentOffset.x : collectionView.contentOffset.y
        let normalizedCenter = (isHorizontal ? attributes.center.x : attributes.center.y) - offset
        
        let maxDistance = (isHorizontal ? self.itemSize.width : self.itemSize.height) + self.minimumLineSpacing
        let distance = min(abs(collectionCenter - normalizedCenter), maxDistance)
        let ratio = (maxDistance - distance)/maxDistance
        
        let alpha = ratio * (1 - self.sideItemAlpha) + self.sideItemAlpha
        let scale = ratio * (1 - self.sideItemScale) + self.sideItemScale
        attributes.alpha = alpha
        attributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        
        return attributes
    }
}
