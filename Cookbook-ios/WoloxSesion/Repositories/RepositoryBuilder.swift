//
//  RepositoryBuilder.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 5/15/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import Foundation
import Networking

class RepositoryBuilder {
    static var DefaultNetworkingConfiguration: NetworkingConfiguration {
        var config = NetworkingConfiguration()
        config.domainURL = "pacific-wave-13746.herokuapp.com"
        config.useSecureConnection = true
        return config
    }
    
    static let DefaultSessionRepository = SesionRepository(configuration: RepositoryBuilder.DefaultNetworkingConfiguration)
}

enum WoloxSigninError: CustomRepositoryErrorType {
    var name: String {
        return "WoloxSigningError"
    }
    
    case loginError(String)
}
