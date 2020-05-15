//
//  UIViewController+Extension.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 5/14/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
