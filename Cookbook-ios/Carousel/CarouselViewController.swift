//
//  CarouselViewController.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 12/24/19.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class CarouselViewController: UIViewController {
    
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    
    private var cellWidth: CGFloat {
        let screenSize = UIScreen.main.bounds.size
        return floor(screenSize.width * 0.6)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCardsCollectionView()
    }
    
    func configureCardsCollectionView()  {
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        carouselCollectionView.register(UINib.init(nibName: ViewNames.carouselCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: ViewNames.carouselCollectionViewCell)
        carouselCollectionView.showsHorizontalScrollIndicator = false
        carouselCollectionView.showsVerticalScrollIndicator = false
        carouselCollectionView.collectionViewLayout = configureCollectionViewFlowLayout(collectionView: carouselCollectionView)
    }
    
    func configureCollectionViewFlowLayout(collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = UIScreen.main.bounds.size.width * 0.07
        return collectionViewLayout
    }
}

// MARK: - Collection delegate and data source
extension CarouselViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewNames.carouselCollectionViewCell, for: indexPath) as? CarouselCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}

// MARK: - Flow layout delegate
extension CarouselViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let size = CGSize(width: cellWidth, height: 400)
        layout.itemSize = size
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Center all elements setting left and right insets
        let insetX = (view.bounds.width - cellWidth) / 2
        return UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
    }
}

// MARK: - Scroll delegate
extension CarouselViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Complete the scroll to one of the cells and center it
        let layout = carouselCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidhtIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidhtIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidhtIncludingSpacing - scrollView.contentInset.left,
                         y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}
