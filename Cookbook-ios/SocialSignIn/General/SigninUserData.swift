//
//  SigninUserData.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 5/7/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import Foundation

struct SigninUserData: Codable {
    let name: String?
    let email: String?
    let imageString: String?
    let signinType: SocialSigninType
    
    func encode() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
    
    static func decode(_ data: Data) -> SigninUserData? {
        let decoder = JSONDecoder()
        return try? decoder.decode(self, from: data)
    }
}

enum SocialSigninType: String, Codable, CaseIterable {
    case facebook
    case gmail
    case apple
    
    var signinManager: SocialNetworkSigninProtocol.Type {
        switch self {
        case .facebook: return FacebookSigninManager.self
        case .gmail: return GoogleSigninManager.self
        case .apple: return FacebookSigninManager.self //TODO: change this with apple manager
        }
    }
    
    func signin() {
        print(signinManager)
    }
}
