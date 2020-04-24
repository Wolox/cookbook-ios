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
    @IBOutlet weak var profileImage: UIImageView!
    
    private var userData: UserData? {
        didSet {
            nameLabel.text = userData?.name ?? SigninStringConstants.noValidName
            emailLabel.text = userData?.email ?? SigninStringConstants.noValidEmail
            if let imageString = userData?.imageString {
                profileImage.download(from: imageString, contentMode: .scaleAspectFit)
            } else {
                profileImage.image = .emptyProfilePicture
            }
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
        _facebookManager.getFacebookUserData { userData in
            self.updateUserData(userData)
        }
    }
    
    func updateUserData(_ newUserData: UserData?) {
        userData = newUserData
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
        // Check for an existing token, if it does not exists means there is no active sesion and call facebook signin
        if let _ = AccessToken.current {
            showMessage(SigninStringConstants.facebookSignedin)
        } else {
            _facebookManager.signin(in: self, completionHandler: { [weak self] userData in
                self?.updateUserData(userData)})
        }
    }
    
    @IBAction func logout() {
        _ = _facebookManager.signout()
        updateExistingSesion()
    }
}
