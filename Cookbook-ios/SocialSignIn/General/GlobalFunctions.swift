//
//  GlobalFunctions.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 4/3/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import Foundation

func saveSigninData(_ data: SigninUserData) {
    guard let encodedData = data.encode() else { return }
    UserDefaultsManager.saveSignedinData(encodedData)
}

func getSignedinData() -> SigninUserData? {
    guard let data = UserDefaultsManager.getSignedinData(), let userData = SigninUserData.decode(data) else { return nil }
    return userData
}
