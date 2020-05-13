//
//  WoloxSigninViewController.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 5/13/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class WoloxSigninViewController: UIViewController {
    //MARK: - Constants
    let viewContentHeight: CGFloat = 530
    
    // MARK: - IBOUtlets
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var userErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var generalErrorView: UIView!
    @IBOutlet weak var generalErrorLabel: UILabel!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    //MARK: Lifecylcle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }
    
    // MARK: Configuration methods
    private func setupView() {
        guard let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets else { return }
        let safeAreaHeight = view.frame.height - safeAreaInsets.top - safeAreaInsets.bottom
        contentHeightConstraint.constant = max(viewContentHeight, safeAreaHeight)
        hideErrors()
    }
    
    private func hideErrors() {
        userErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        generalErrorView.isHidden = true
    }
    
    //MARK: Action methods
    @IBAction func login(_ sender: Any) {
        
    }
    
    @IBAction func registerNewUser(_ sender: Any) {
        
    }
}
