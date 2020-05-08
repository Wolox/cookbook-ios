//
//  SocialNetworkSigninProtocol.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 3/31/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

typealias signinCompletionHandler = (SigninUserData?) -> Void

protocol SocialNetworkSigninProtocol {
    static var sharedInstance: SocialNetworkSigninProtocol? { get }
    static func getSharedInstance() -> SocialNetworkSigninProtocol
    func signin(in viewController: UIViewController)
    func signout()
    func isUserActive() -> Bool
    func getUserStringToken() -> String?
}
