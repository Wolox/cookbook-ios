//
//  TextFieldsTableViewCell.swift
//  Cookbook-ios
//
//  Created by Matias Schwalb on 29/01/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class TextFieldsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = .cardsBackground
        }
    }
    @IBOutlet weak var acceptButton: UIButton! {
        didSet {
            acceptButton.backgroundColor = .woloxGreen
            acceptButton.tintColor = .white
            acceptButton.layer.cornerRadius = acceptButton.frame.height / 4
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        loadTextField()
    }
    
    private func loadTextField() {
        let textField = UITextField(frame: containerView.bounds)
        textField.backgroundColor = .woloxBlue
        textField.alpha = 0.5
        containerView.addSubview(textField)
    }
    
}
