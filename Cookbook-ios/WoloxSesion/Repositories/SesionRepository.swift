//
//  SesionRepository.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 5/15/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import Argo
import Result
import ReactiveSwift
import Networking
import ReactiveSwift

protocol SesionRepositoryType {
    func login(_ username: String, password: String) -> SignalProducer<User, RepositoryError>
}

class SesionRepository: AbstractRepository, SesionRepositoryType {

    private let loginPath = "/login"

    private let woloxSigninErrorName = "Error"

    func login(_ username: String, password: String) -> SignalProducer<User, RepositoryError> {
        let path = loginPath
        let parameters: [String: Any] = ["username": username,
                                         "password": password]
        return performRequest(method: .post, path: path, parameters: parameters) { JSON in
            return decode(JSON).toResult()
            }.mapError { error in //TODO: validate this
                switch error {
                case .unauthenticatedSession(let reqerror), .requestError(let reqerror):
                    let myerror = WoloxSigninError.loginError((reqerror.body?["code"] as? String) ?? "")
                    return RepositoryError.customError(errorName: self.woloxSigninErrorName,
                                                       error: myerror)
                default: return error
                }
        }
    }
}
