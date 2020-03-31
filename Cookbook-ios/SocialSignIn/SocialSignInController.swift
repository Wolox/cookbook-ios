//
//  SocialSignInController.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 3/30/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit

class SocialSignInController: GeneralViewController {
    // MARK: - Outlet properties
    @IBOutlet weak var facebookLoginButton: CookBookButton! {
        didSet {
            facebookLoginButton.backgroundColor = .facebookColor
        }
    }
    @IBOutlet weak var googleLoginButton: CookBookButton! {
        didSet {
            googleLoginButton.backgroundColor = .googleColor
        }
    }
    @IBOutlet weak var appleLoginButton: CookBookButton! {
        didSet {
            appleLoginButton.backgroundColor = .gray //TODO: change color
        }
    }
    @IBOutlet weak var logoutButton: CookBookButton! {
        didSet {
            logoutButton.backgroundColor = .woloxGreen
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    private var userName: String? {
        didSet {
            nameLabel.text = userName ?? SigninStringConstants.noValidName
        }
    }
    private var userEmail: String? {
        didSet {
            emailLabel.text = userEmail ?? SigninStringConstants.noValidEmail
        }
    }
    
    // MARK: Private proterties
    private let _facebookManager = FacebookSigninManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feature = Features.socialSignIn
        configureNavigationBar()
        updateExistingSesion()
    }
}

private extension SocialSignInController {
    func updateExistingSesion() {
        _facebookManager.getFacebookUserData { (name, email) in
            self.updateUserData(name: name, email: email)
        }
    }
    
    func updateUserData(name: String?, email: String?) {
        userName = name
        userEmail = email
    }
    
    func showMessage(_ text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil) })
    }
}

// MARK: - Button actions
extension SocialSignInController {
    @IBAction func facebookLogin() {
        if let _ = AccessToken.current {
            showMessage(SigninStringConstants.facebookSignedin)
        } else {
            _facebookManager.login(in: self, completionHandler: { [weak self] name, email in
            self?.updateUserData(name: name, email: email)})
        }
    }
    
    @IBAction func logout() {
        _ = _facebookManager.logout()
        updateExistingSesion()
    }
}
