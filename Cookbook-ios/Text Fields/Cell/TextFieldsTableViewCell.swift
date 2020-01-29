//
//  TextFieldsTableViewCell.swift
//  Cookbook-ios
//
//  Created by Matias Schwalb on 29/01/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class TextFieldsTableViewCell: UITableViewCell {
    
    var acceptButtonPressed: ((String?) -> Void)?
    var clearTextField: (() -> Void)?
    
    var textField: UITextField?
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = .cardsBackground
        }
    }
    @IBOutlet weak var acceptButton: UIButton! {
        didSet {
            acceptButton.layer.cornerRadius = acceptButton.frame.height / 4
            if acceptButton.isEnabled {
                acceptButton.backgroundColor = .woloxGreen
                acceptButton.tintColor = .white
            } else {
                acceptButton.backgroundColor = .lightGray
                acceptButton.tintColor = .black
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadTextField()
        setupButtonAction()
        acceptButton.isEnabled = false
    }
    
    private func setupButtonAction() {
        acceptButton.addTarget(self, action: #selector(pressed(sender:)), for: .touchUpInside)
    }
    
    @objc func pressed(sender: UIButton!) {
        print("accept button pressed: \(textField?.text)")
        acceptButtonPressed?(textField?.text)
    }
    
    private func loadTextField() {
        let textField = UITextField(frame: containerView.layer.bounds)
        self.textField = textField
        textField.backgroundColor = .woloxBlue
        textField.alpha = 0.5
        textField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        clearTextField = { [weak self] in
            textField.text = ""
            self?.acceptButton.isEnabled = false
        }
        
        containerView.addSubview(textField)
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        
        acceptButton.isEnabled = !(textField.text?.isEmpty ?? true)
    }
}
