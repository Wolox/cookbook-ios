//
//  FacebookSigninManager.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 3/30/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

protocol SocialNetworkSigninProtocol {
    typealias signinCompletionHandler = (UserData?) -> Void
    func signin(in viewController: UIViewController, completionHandler: @escaping signinCompletionHandler)
    func signout()
}

/* If your app asks for more than the profile default fields and email, Facebook must review it before you release it. Please see this documentation https://developers.facebook.com/docs/facebook-login/review for reviewing your app
 Facebook Swift SDK documentation: https://developers.facebook.com/docs/swift/login
 */
class FacebookSigninManager: SocialNetworkSigninProtocol {
    let loginManager = LoginManager()
    
    func signin(in viewController: UIViewController, completionHandler: @escaping signinCompletionHandler) {
        // Set the data permissions you require for your appliation
        loginManager.logIn(permissions: [ .publicProfile, .email ],
                           viewController: viewController,
                           completion: { result in self.loginManagerDidComplete(result, completionHandler: completionHandler) })
    }
    
    func signout() {
        loginManager.logOut()
    }
    
    private func loginManagerDidComplete(_ result: LoginResult, completionHandler: @escaping signinCompletionHandler) {
        switch result {
        case .success(granted: _, declined: _, token: _):
            getFacebookUserData(completionHandler: completionHandler)
        case .failed(let error): //TODO: define what supose to do here
            print("Facebook sign in error: \(error)")
        case .cancelled: //TODO: define what supose to do here
            return
        }
    }
    
    func getFacebookUserData(completionHandler: @escaping signinCompletionHandler) {
        // Set the data you need to get from user's public profile https://developers.facebook.com/docs/swift/reference/structs/userprofile.html
        let params = ["fields": "name, email, picture.type(large)"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            guard error == nil else {
                completionHandler(nil)
                return
            }
            
            let result = result as AnyObject
            let name  = result["name"] as? String
            let email = result["email"] as? String
            let imageURL = ((result["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
            let userData = UserData(name: name, email: email, imageString: imageURL)
            completionHandler(userData)
        })
    }
}

struct UserData {
    let name: String?
    let email: String?
    let imageString: String?
}
