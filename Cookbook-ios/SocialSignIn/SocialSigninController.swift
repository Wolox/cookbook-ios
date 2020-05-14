//
//  SocialSigninControllerTest.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 4/3/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class SocialSignInController: GeneralViewController {
    // MARK: - Outlet properties
    @IBOutlet weak var facebookLoginButton: UIButton! {
        didSet {
            //TODO: fix button style
            facebookLoginButton.setCookBookStyle(withColor: .facebookColor)
            facebookLoginButton.setTitle(title: "Sign in with Facebook", image: .facebookLogo)
        }
    }
    @IBOutlet weak var googleLoginButton: UIButton! {
        didSet {
            googleLoginButton.setCookBookStyle(withColor: .googleColor)
        }
    }
    @IBOutlet weak var appleLoginButton: UIButton! {
        didSet {
            appleLoginButton.setCookBookStyle(withColor: .gray) //TODO: change color
        }
    }
    @IBOutlet weak var logoutButton: UIButton! {
        didSet {
            logoutButton.setCookBookStyle(withColor: .woloxGreen)
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    // MARK: private properties
    private var _observer: NSKeyValueObservation?
    private var _userData: SigninUserData? {
        didSet {
            nameLabel.text = _userData?.name ?? SigninStringConstants.noValidName
            emailLabel.text = _userData?.email ?? SigninStringConstants.noValidEmail
            if let imageString = _userData?.imageString {
                profileImage.download(from: imageString, contentMode: .scaleAspectFit)
            } else {
                profileImage.image = .emptyProfilePicture
            }
        }
    }
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        feature = Features.socialSignIn
        configureNavigationBar()
        getSignedinUser()
        _observer = UserDefaults.standard.observe(\.signedinData, options: [.new, .old], changeHandler: { [weak self] (defaults, change) in
            guard let self = self else { return }
            guard let data = change.newValue as? Data, let userData = SigninUserData.decode(data) else {
                self._userData = nil
                return
            }
            self._userData = userData
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _observer?.invalidate()
    }
    
    // MARK: - private methods
    private func getSignedinUser() {
        //TODO: validate active sesion
        guard let userData = getSignedinData() else { return }
        _userData = userData
    }
    
    private func showMessage(_ text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil) })
    }
}

// MARK: - Button actions
extension SocialSignInController {
    @IBAction func facebookLogin() {
        logoutAllSocialSignin()
        let facebookManager = SocialSigninType.facebook.signinManager.getSharedInstance()
        facebookManager.signin(in: self)
    }
    
    @IBAction func googleLogin() {
        logoutAllSocialSignin()
        let googleManager = SocialSigninType.gmail.signinManager.getSharedInstance()
        googleManager.signin(in: self)
    }
    
    @IBAction func logout() {
        guard let userData = getSignedinData() else { return }
        let manager = userData.signinType.signinManager.getSharedInstance()
        manager.signout()
    }
    
    private func logoutAllSocialSignin() {
        SocialSigninType.allCases.forEach { socialCase in
            let manager = socialCase.signinManager.getSharedInstance()
            manager.signout()
        }
    }
}
