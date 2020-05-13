//
//  WoloxSigninViewModel.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 5/13/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import Foundation
import ReactiveSwift

class WoloxSigninViewModel {
    let userMutableProperty = MutableProperty<String>("")
    let passwordMutableProperty = MutableProperty<String>("")
    public private(set) lazy var signinAction: Action<(), Bool, Error> = Action {
        SignalProducer.empty
    }
    
    init() {
        let userValid = userMutableProperty.producer.map { !$0.isEmpty }
        let passwordValid = passwordMutableProperty.producer.map { !$0.isEmpty }
        
        let canExecuteSignin = SignalProducer
            .combineLatest(userValid, passwordValid)
            .map { $0 && $1 }
        
        let canExecuteSigninProperty = Property(initial: false, then: canExecuteSignin)
        signinAction = Action(enabledIf: canExecuteSigninProperty) { [unowned self] _ in
            return self.sigin()
        }
    }
    
    func sigin() -> SignalProducer<Bool, Error> {
        return SignalProducer.init(value: true)
    }
}
