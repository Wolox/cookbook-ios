//
//  UserDefaultsManager.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 4/3/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import Foundation

class UserDefaultsManager {
    static let signingDataKey = "signedinData"
    
    static func saveSignedinData(_ data: Data) {
        UserDefaults.standard.set(data, forKey: UserDefaultsManager.signingDataKey)
    }
    
    static func getSignedinData() -> Data? {
        UserDefaults.standard.data(forKey: UserDefaultsManager.signingDataKey)
    }
    
    static func removeSignedinData() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsManager.signingDataKey)
    }
}

extension UserDefaults {
    @objc dynamic var signedinData: Data? {
        return data(forKey: "signedinData")
    }
}
