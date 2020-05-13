//
//  TitleSectionHeader.swift
//  Essen
//
//  Created by Matías Spinelli on 03/10/2019.
//  Copyright © 2019 Wolox. All rights reserved.
//

import UIKit

class TitleSectionHeader: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: 18)
            titleLabel.textColor = .black
        }
    }
}
