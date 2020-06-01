//
//  UserDefaultsService.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 5/27/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import Foundation

class UserDefaultsService {
    static let shared = UserDefaultsService()
    
    private let tokenKey = "sessionToken"
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }

}
