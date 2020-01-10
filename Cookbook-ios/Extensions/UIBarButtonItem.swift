//
//  UIBarButtonItemExtension.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 1/8/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    static func informationButton(target: UIViewController, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(UIImage.informationImage, for: .normal)
        button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        barButton.customView?.widthAnchor.constraint(equalToConstant: 30).isActive = true
        barButton.customView?.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return barButton
    }
}
