//
//  CarouselViewController.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 12/24/19.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

// Show elements in a carousel. Cell size, sideItemScale, sideItemAlpha, sideSpacing and scrollDirection must be set as required.
class CarouselViewController: GeneralViewController {
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    
    private var _cellWidth: CGFloat {
        let screenSize = UIScreen.main.bounds.size
        return floor(screenSize.width * 0.7)
    }
    private var _cellHeight: CGFloat {
        let screenSize = UIScreen.main.bounds.size
        return floor(screenSize.height * 0.5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feature = Features.carousel
        configureNavigationBar()
        configureCardsCollectionView()
    }
    
    // MARK: - Configuration methods
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        configureInformationButton()
    }
    func configureCardsCollectionView()  {
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        carouselCollectionView.register(UINib.init(nibName: ViewNames.carouselCollectionViewCell, bundle: nil),
                                        forCellWithReuseIdentifier: ViewNames.carouselCollectionViewCell)
        carouselCollectionView.showsHorizontalScrollIndicator = false
        carouselCollectionView.showsVerticalScrollIndicator = false
        carouselCollectionView.collectionViewLayout = configureCollectionViewFlowLayout(collectionView: carouselCollectionView)
    }
    
    func configureCollectionViewFlowLayout(collectionView: UICollectionView) -> UICollectionViewFlowLayout {
        let collectionViewLayout = CarouselFlowLayout(sideItemScale: 0.9,
                                                      sideItemAlpha: 0.6,
                                                      sideSpacing: 20)
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.itemSize = CGSize(width: _cellWidth,
                                               height: _cellHeight)
        return collectionViewLayout
    }
}

// MARK: - Collection delegate and data source
extension CarouselViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Features.allCases.count - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewNames.carouselCollectionViewCell,
                                                            for: indexPath) as? CarouselCollectionViewCell else {
            return UICollectionViewCell()
        }
        let feature = Features.allCases[indexPath.row + 1]
        cell.configureCellWith(title: feature.featureName, image: feature.featureImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let feature = Features.allCases[indexPath.row + 1]
        let viewController = feature.viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
}
