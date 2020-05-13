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
    lazy var isValidUser = Property(initial: false, then: self.userMutableProperty.skipRepeats().map { !$0.isEmpty })
    lazy var isValidPassword = Property(initial: false, then: self.passwordMutableProperty.skipRepeats().map { !$0.isEmpty })
    public private(set) lazy var signinAction: Action<(), Bool, Error> = Action {
        SignalProducer.empty
    }
    
    init() {
        let canExecuteSignin = SignalProducer
            .combineLatest(isValidUser, isValidPassword)
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
