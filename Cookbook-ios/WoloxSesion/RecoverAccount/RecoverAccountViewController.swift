//
//  RecoverAccountViewController.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 6/19/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class RecoverAccountViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNativationBar()
    }
    
    private func configureNativationBar() {
        let recoverButton = UIBarButtonItem(title: SigninStringConstants.recoverAccount, style: .done, target: self, action: #selector(recoverPressed))
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: target, action: #selector(cancelPressed))
        navigationItem.rightBarButtonItem = recoverButton
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem?.tintColor = .woloxBlue
        navigationItem.leftBarButtonItem?.tintColor = .woloxBlue
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    @objc private func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func recoverPressed() {
        dismiss(animated: true, completion: nil)
    }
}
