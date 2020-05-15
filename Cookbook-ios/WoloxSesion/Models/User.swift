//
//  User.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 5/15/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import Foundation
import Argo
import Runes
import Curry

struct User {
    let name: String
    let email: String
}

extension User: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<User> {
        return curry(User.init)
            <^> json <| "name"
            <*> json <| "email"
    }
}
