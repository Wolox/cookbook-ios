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
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.isSecureTextEntry = true
            passwordTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: passwordTextField.frame.height))
            passwordTextField.rightViewMode = .always
        }
    }
    @IBOutlet weak var signinButton: UIButton! {
        didSet {
            signinButton.backgroundColor = .woloxBlue
            signinButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var registerButton: UIButton! {
        didSet {
            registerButton.setTitleColor(.woloxBlue, for: .normal)
        }
    }
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var showPasswordButton: UIButton! {
        didSet {
            showPasswordButton.imageView?.tintColor = UIColor.woloxBlue
            let image = (UIImage.eyeOn).withRenderingMode(.alwaysTemplate)
            showPasswordButton.setImage(image, for: .normal)
        }
    }
    
    //MARK: - Lifecylcle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        hideKeyboardOnTap()
        configureTextFields()
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
    
    private func configureTextFields() {
        userTextField.delegate = self
        passwordTextField.delegate = self
        configureBasicTextField(userTextField)
        configureBasicTextField(passwordTextField)
    }
    
    private func bindViewModel() {
        viewModel.userMutableProperty <~ userTextField.reactive.continuousTextValues
        viewModel.passwordMutableProperty <~ passwordTextField.reactive.continuousTextValues
        
        signinButton.reactive.pressed = CocoaAction(viewModel.signinAction)
        viewModel.signinAction.isExecuting.producer.observe(on: UIScheduler()).startWithValues { [weak self] isExecuting in
            if isExecuting {
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
    
    private func configureBasicTextField(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4
        textField.layer.borderColor = UIColor.woloxGrayBorder.cgColor
    }
    
    // MARK: - Helper methods
    private func showCarousel() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = CarouselViewController(nibName: ViewNames.carouselView, bundle: nil)
        window.rootViewController = viewController
    }
    
    //MARK: - Action methods
    @IBAction func showPasswordPressed(_ sender: Any) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        var image: UIImage = passwordTextField.isSecureTextEntry ? .eyeOn : .eyeOff
        image = image.withRenderingMode(.alwaysTemplate)
        showPasswordButton.setImage(image, for: .normal)
    }
    
    @IBAction func recoverAccount(_ sender: Any) {
        let recoverAccountviewController = RecoverAccountViewController(nibName: ViewNames.recoverAccountView, bundle: nil)
        let navigationController = UINavigationController(rootViewController: recoverAccountviewController)
        present(navigationController, animated: true)
    }
}

extension WoloxSigninViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.layer.borderWidth = 4
        textField.layer.borderColor = UIColor.woloxBlueBorder.cgColor
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        configureBasicTextField(textField)
    }
}
