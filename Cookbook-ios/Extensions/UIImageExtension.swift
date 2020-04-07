//
//  UIImageExtension.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 1/8/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

extension UIImage {
    static let informationImage = UIImage(imageLiteralResourceName: "information")
    static let scannerImage = UIImage(imageLiteralResourceName: "scan")
    static let focusedImage = UIImage(imageLiteralResourceName: "focused")
    static let placesImage = #imageLiteral(resourceName: "places")
    
    // MARK: SF symbols - only for iOS 13 +
    
    /* If you want to use this icons you need to download SF symbols: https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/ */
    
    static let fullscreenImage = getSystemImage(string: "arrow.up.left.and.arrow.down.right")
    static let onScreenResult = getSystemImage(string: "chevron.down.square")
    static let customResult = getSystemImage(string: "hammer")
    
    static func getSystemImage(string: String) -> UIImage? {
        if #available(iOS 13.0, *) {
            return UIImage(systemName: string)
        } else {
            return nil
        }
    }
}
