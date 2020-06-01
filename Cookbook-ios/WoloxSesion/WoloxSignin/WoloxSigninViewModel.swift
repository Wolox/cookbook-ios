//
//  WoloxSigninViewModel.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 5/13/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import Foundation
import ReactiveSwift
import Networking

class WoloxSigninViewModel {
    private let _sesionRepository: SesionRepositoryType
    let userMutableProperty = MutableProperty<String>("")
    let passwordMutableProperty = MutableProperty<String>("")
    lazy var isValidUser = Property(initial: false, then: self.userMutableProperty.skipRepeats().map { !$0.isEmpty })
    lazy var isValidPassword = Property(initial: false, then: self.passwordMutableProperty.skipRepeats().map { !$0.isEmpty })
    public private(set) lazy var signinAction: Action<(), Void, RepositoryError> = Action {
        SignalProducer.empty
    }
    
    init(repository: SesionRepositoryType) {
        _sesionRepository = repository
        let canExecuteSignin = SignalProducer
            .combineLatest(isValidUser, isValidPassword)
            .map { $0 && $1 }
        
        let canExecuteSigninProperty = Property(initial: false, then: canExecuteSignin)
        signinAction = Action(enabledIf: canExecuteSigninProperty) { [unowned self] _ in
            return self.sigin()
        }
    }
    
    func sigin() -> SignalProducer<Void, RepositoryError> {
        return _sesionRepository.login(userMutableProperty.value, password: passwordMutableProperty.value)
    }
}
