//
//  GoogleSigninManager.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 4/3/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import Foundation
import GoogleSignIn

// Follow Start integrating documentation if using Cocoapods and Start integrating without CocoaPods if using Carthage https://developers.google.com/identity/sign-in/ios/sdk/
class GoogleSigninManager: NSObject, SocialNetworkSigninProtocol {
    static var sharedInstance: SocialNetworkSigninProtocol?
    static func getSharedInstance() -> SocialNetworkSigninProtocol {
        if sharedInstance == nil {
            sharedInstance = GoogleSigninManager()
        }
        
        return sharedInstance!
    }
    
    override init() {
        super.init()
        // Replace the cliend ID with the one you got after register your app
        GIDSignIn.sharedInstance().clientID = "968789930024-36aj4vm1teg0mi712f6isc7tsva02llj.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        // Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    func signin(in viewController: UIViewController) {
        GIDSignIn.sharedInstance()?.presentingViewController = viewController
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signout() {
        GIDSignIn.sharedInstance().signOut()
        UserDefaultsManager.removeSignedinData()
    }
    
    func isUserActive() -> Bool {
        return !(getUserStringToken()?.isEmpty ?? true)
    }
    
    func getUserStringToken() -> String? {
        guard let currentUser = GIDSignIn.sharedInstance()?.currentUser else { return nil }
        return currentUser.authentication.idToken
    }
    
    func getUserData(completionHandler: @escaping signinCompletionHandler) {
        guard let currentUser = GIDSignIn.sharedInstance()?.currentUser else {
            completionHandler(nil)
            return
        }
        
        let name = currentUser.profile.name
        let email = currentUser.profile.email
        let userData = SigninUserData(name: name, email: email, imageString: nil, signinType: .gmail)
        completionHandler(userData)
    }
}

// MARK: Google sign in delegate methods
extension GoogleSigninManager: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        let name = user.profile.name
        let email = user.profile.email
        let userData = SigninUserData(name: name, email: email, imageString: nil, signinType: .gmail)
        saveSigninData(userData)
        
    }
        
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        guard let userData = getSignedinData(), userData.signinType == .gmail else { return }
        signout()
    }
}
