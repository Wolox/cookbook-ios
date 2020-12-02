//
//  UIColorExtension.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 1/8/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

extension UIColor {
    static let woloxGreen = UIColor(red: 149/255, green: 198/255, blue: 44/255, alpha: 1)
    static let tintColor = UIColor(red: 93/255, green: 173/255, blue: 226/255, alpha: 1)
    static let cardsBackground = UIColor.woloxGreen.withAlphaComponent(0.3)
    static let shadow = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2).cgColor
}
