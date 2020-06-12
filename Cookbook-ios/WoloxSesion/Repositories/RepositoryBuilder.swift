//
//  RepositoryBuilder.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 5/15/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import Foundation
import Networking

// https://github.com/IgnOliveto/jwtReference
class RepositoryBuilder {
    static var DefaultNetworkingConfiguration: NetworkingConfiguration {
        var config = NetworkingConfiguration()
        config.domainURL = "login-node-wolox.herokuapp.com"
        config.useSecureConnection = true
        config.interceptor = TokenGetter.shared
        return config
    }
    
    static let DefaultSessionRepository = SesionRepository(configuration: RepositoryBuilder.DefaultNetworkingConfiguration)
}

enum WoloxSigninError: CustomRepositoryErrorType {
    var name: String {
        return "SigningError"
    }
    
    case loginError(String)
}

class TokenGetter: NetworkingInterceptor {
    static let shared: TokenGetter = TokenGetter()
    private var _token: String?
    
    public func intercept(request: URLRequest, response: HTTPURLResponse, data: Data) {
        if let headerToken = response.allHeaderFields["Token"] as? String {
            _token = headerToken
            UserDefaultsService.shared.saveToken(headerToken)
        }
    }
}
