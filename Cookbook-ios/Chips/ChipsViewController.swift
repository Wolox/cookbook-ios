//
//  ChipsViewController.swift
//  Cookbook-ios
//
//  Created by Matías Spinelli on 08/02/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class ChipsViewController: GeneralViewController {

    private var _categorizedChips: [[Chip]] = []
    public var filterTags: [Chip] = []

    @IBOutlet weak var chipsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _categorizedChips = [[Chip(id: 1, type: "Type", name: "Name 1"), Chip(id: 2, type: "Type", name: "Name 2")], [Chip(id: 3, type: "Type Dos", name: "Name Name 3"), Chip(id: 4, type: "Type Dos", name: "Name 4"), Chip(id: 5, type: "Type Dos", name: "Name Name 5"), Chip(id: 6, type: "Type Dos", name: "Name Name 6"), Chip(id: 7, type: "Type Dos", name: "Name 7"), Chip(id: 8, type: "Type Dos", name: "Name 8"), Chip(id: 9, type: "Type Type", name: "Name 9")], [Chip(id: 10, type: "Type Tres", name: "Name 10"), Chip(id: 11, type: "Type", name: "Name 11"), Chip(id: 12, type: "Type Tres", name: "Name 12")]]
        
        setupTable()
    }

    private func setupTable() {
        chipsCollectionView.delegate = self
        chipsCollectionView.dataSource = self
        
        chipsCollectionView.register(UINib(nibName: ViewNames.chipsViewCell, bundle: nil), forCellWithReuseIdentifier: ViewNames.chipsViewCell)
        chipsCollectionView.register(UINib(nibName: ViewNames.titleSectionHeader, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ViewNames.titleSectionHeader)
        let leftLayout: LeftAlignedCollectionViewFlowLayout = LeftAlignedCollectionViewFlowLayout()
        
        leftLayout.minimumInteritemSpacing = 10
        leftLayout.minimumLineSpacing = 10
        chipsCollectionView.collectionViewLayout = leftLayout
    }
}

extension ChipsViewController: ChipViewCellProtocol {

    func chipSelected(chipViewCell: ChipViewCell) {
        /**
         Here you can do something with the chip =P
         */
        chipViewCell.chipButton.isSelected.toggle()
        chipViewCell.configureChipButton()
    }
}

extension ChipsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ViewNames.titleSectionHeader, for: indexPath) as? TitleSectionHeader else {
                return UICollectionReusableView()
            }
            let tags = _categorizedChips[indexPath.section]
            if !tags.isEmpty {
                sectionHeader.titleLabel.text = tags.first?.type
            }
            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _categorizedChips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tags = _categorizedChips[section]
        if !tags.isEmpty {
            return tags.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewNames.chipsViewCell, for: indexPath) as? ChipViewCell else {
            return UICollectionViewCell()
        }
        
        let tags = _categorizedChips[indexPath.section]
        if !tags.isEmpty {
            let tag = tags[indexPath.row]
            let tagSelected = filterTags.contains(tag)
            cell.chipButton.isSelected = tagSelected
            
            cell.setup(with: tag.name)
            cell.delegate = self
        }
        return cell
    }
}

extension ChipsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let tags = _categorizedChips[indexPath.section]
        if !tags.isEmpty {
            let tag = tags[indexPath.row]
            let tagName = tag.name
            let font = UIFont.systemFont(ofSize: 14)
            let cellSize = collectionView.textSize(text: tagName, font: font)
            return cellSize
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

// MOVER A UN ARCHIVO DE EXTENSIONES
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
