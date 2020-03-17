//
//  FocusedTableController.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 3/6/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class FocusedCollectionController: GeneralViewController {
    @IBOutlet weak var focusedCollectionView: UICollectionView!
    
    private let _colors = FocusedColors
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feature = Features.focusedTable
        configureNavigationBar()
        configureFocusedCollectionView()
    }
    
    private func configureFocusedCollectionView() {
        focusedCollectionView.delegate = self
        focusedCollectionView.dataSource = self
        focusedCollectionView.register(UINib(nibName: ViewNames.focusedCollectionViewCell, bundle: nil),
                                       forCellWithReuseIdentifier: ViewNames.focusedCollectionViewCell)
        focusedCollectionView.collectionViewLayout = configureCollectionViewFlowLayout(collectionView: focusedCollectionView)
    }
    
    func configureCollectionViewFlowLayout(collectionView: UICollectionView) -> UICollectionViewLayout {
        return FocusedLayout()
    }
}

extension FocusedCollectionController:  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewNames.focusedCollectionViewCell, for: indexPath) as? FocusedCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.color = _colors[indexPath.row]
        return cell
    }
}