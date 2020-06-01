//
//  WoloxSigninViewController.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 5/13/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class WoloxSigninViewController: UIViewController {
    //MARK: - Constants
    let viewContentHeight: CGFloat = 550
    
    // MARK: - Properties
    var viewModel: WoloxSigninViewModel!
    
    // MARK: - IBOUtlets
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var userErrorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var generalErrorView: UIView!
    @IBOutlet weak var generalErrorLabel: UILabel!
    @IBOutlet weak var signinButton: UIButton! {
        didSet {
            signinButton.backgroundColor = .woloxGreen
            signinButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            registerButton.setTitleColor(.woloxGreen, for: .normal)
        }
    }
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Lifecylcle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        hideErrors()
        hideKeyboardOnTap()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupView()
    }
    
    // MARK: - Configuration methods
    private func setupView() {
        guard let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets else { return }
        let safeAreaHeight = view.frame.height - safeAreaInsets.top - safeAreaInsets.bottom
        contentHeightConstraint.constant = max(viewContentHeight, safeAreaHeight)
    }
    
    private func hideErrors() {
        userErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        generalErrorView.isHidden = true
    }
    
    private func bindViewModel() {
        viewModel.userMutableProperty <~ userTextField.reactive.continuousTextValues
        viewModel.passwordMutableProperty <~ passwordTextField.reactive.continuousTextValues
        userErrorLabel.reactive.isHidden <~ viewModel.isValidUser.producer
        passwordErrorLabel.reactive.isHidden <~ viewModel.isValidPassword.producer
        
        signinButton.reactive.pressed = CocoaAction(viewModel.signinAction)
        viewModel.signinAction.isExecuting.producer.observe(on: UIScheduler()).startWithValues { [weak self] isExecuting in
            if isExecuting {
                self?.hideErrors()
                //TODO: show loading
            } else {
                //TODO: hide loading
            }
        }
        
        viewModel.signinAction.isEnabled.producer.observe(on: UIScheduler()).startWithValues { [weak self] isEnabled in
            let alpha: CGFloat = isEnabled ? 1.0 : 0.5
            self?.signinButton.backgroundColor = self?.signinButton.backgroundColor?.withAlphaComponent(alpha)
        }
        
        viewModel.signinAction.values.take(during: reactive.lifetime).observeValues { [weak self] _ in
            self?.showCarousel()
        }
        
        viewModel.signinAction.errors.take(during: reactive.lifetime).observeValues { error in
            print("LOGIN ERROR")
        }
    }
    
    // MARK: - Helper methods
    private func showCarousel() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = CarouselViewController(nibName: ViewNames.carouselView, bundle: nil)
        window.rootViewController = viewController
    }
}
