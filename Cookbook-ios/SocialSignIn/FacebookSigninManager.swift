//
//  FacebookSigninManagerTest.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 4/3/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

/* If your app asks for more than the profile default fields and email, Facebook must review it before you release it. Please see this documentation https://developers.facebook.com/docs/facebook-login/review for reviewing your app
 Facebook Swift SDK documentation: https://developers.facebook.com/docs/swift/login
 */
class FacebookSigninManager: SocialNetworkSigninProtocol {
    static var sharedInstance: SocialNetworkSigninProtocol?
    static func getSharedInstance() -> SocialNetworkSigninProtocol {
        if sharedInstance == nil {
            sharedInstance = FacebookSigninManager()
        }
        
        return sharedInstance!
    }
    
    private let loginManager = LoginManager()
    
    func signin(in viewController: UIViewController) {
        loginManager.logIn(
            permissions: [ .publicProfile, .email],
            viewController: viewController,
            completion: { result in self.loginManagerDidComplete(result)})
    }
    
    func signout() {
        guard let userData = getSignedinData(), userData.signinType == .facebook else { return }
        loginManager.logOut()
        UserDefaultsManager.removeSignedinData()
    }
    
    func isUserActive() -> Bool {
        return !(getUserStringToken()?.isEmpty ?? true)
    }
    
    func getUserStringToken() -> String? {
        guard let accessToken = AccessToken.current else { return nil }
        return accessToken.tokenString
    }
    
    func getFacebookUserData() {
        // Set the data you need to get from user's public profile https://developers.facebook.com/docs/swift/reference/structs/userprofile.html
        let params = ["fields": "name, email, picture.type(large)"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            guard error == nil else { return }
            
            let result = result as AnyObject
            let name  = result["name"] as? String
            let email = result["email"] as? String
            let imageURL = ((result["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
            let userData = SigninUserData(name: name, email: email, imageString: imageURL, signinType: .facebook)
            saveSigninData(userData)
        })
    }
    
     private func loginManagerDidComplete(_ result: LoginResult) {
        switch result {
        case .success(granted: _, declined: _, token: _):
            getFacebookUserData()
        case .failed(let error as NSError): //TODO: define what supose to do here
            print("Facebook sign in error: \(error.code)")
        case .cancelled: //TODO: define what supose to do here
            print("Facebook sign in canceled")
        }
    }
}
