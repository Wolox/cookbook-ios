//
//  ChipViewCell.swift
//  Cookbook-ios
//
//  Created by Matías Spinelli on 08/02/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

protocol ChipViewCellProtocol: class {
    func chipSelected(chipViewCell: ChipViewCell)
}

class ChipViewCell: UICollectionViewCell {

    weak var delegate: ChipViewCellProtocol?
    
    private static let tagClosePadding: CGFloat = 10.0
    
    @IBOutlet weak var chipButton: UIButton! {
        didSet {
            chipButton.titleLabel?.numberOfLines = 1
            chipButton.titleLabel?.lineBreakMode = .byTruncatingTail
            chipButton.layer.cornerRadius = 10
        }
    }
    
    func setup(with tag: String) {
        chipButton.setTitle(tag, for: .normal)
        configureChipButton()
    }
    
    func configureChipButton() {
        if chipButton.isSelected {
            chipButton.layer.borderWidth = 0
            chipButton.backgroundColor = UIColor.woloxGreen
            chipButton.setTitleColor(.white, for: .normal)
        } else {
            chipButton.layer.borderWidth = 1
            chipButton.layer.borderColor = UIColor.woloxGreen.cgColor
            chipButton.backgroundColor = .white
            chipButton.setTitleColor(UIColor.woloxGreen, for: .normal)
        }
        chipButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
    }
    
    func addCloseTagImage() {
        chipButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: ChipViewCell.tagClosePadding)
        chipButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: ChipViewCell.tagClosePadding, bottom: 0.0, right: 0.0)
        chipButton.setImage(UIImage.closeMini, for: .normal)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        delegate?.chipSelected(chipViewCell: self)
    }

}
