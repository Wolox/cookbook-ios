//
//  UIButtonExtension.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 3/30/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class CookBookButton: UIButton {
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
}

// MARK: - Setup button methods
private extension CookBookButton {
    func sharedInit() {
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        titleLabel?.textAlignment = .center
        layer.cornerRadius = 15
        setTitleColor(.white, for: .normal)
    }
}
