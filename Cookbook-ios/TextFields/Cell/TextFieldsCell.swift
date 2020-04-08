//
//  TextFieldsCell.swift
//  Cookbook-ios
//
//  Created by Matias David Schwalb on 08/04/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class TextFieldsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let frame = CGRect(x: 20, y: center.y - 15, width: 200, height: 30)
        let textField = KaedeTextField(frame: frame)
        textField.placeholderColor = .darkGray
        textField.foregroundColor = .lightGray
        textField.backgroundColor = .lighterGray
        textField.placeholder = "First Name"
        
        addSubview(textField)
        backgroundColor = .woloxGreen
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
