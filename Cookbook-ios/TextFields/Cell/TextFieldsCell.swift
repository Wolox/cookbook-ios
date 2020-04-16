//
//  TextFieldsCell.swift
//  Cookbook-ios
//
//  Created by Matias David Schwalb on 08/04/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class TextFieldsCell: UITableViewCell {

    var _textField: TextFieldEffects? {
        didSet {
            loadTextField()
            textFieldNameLabel.text = _textField?.name
        }
    }
    
    @IBOutlet weak var textFieldNameLabel: UILabel!
    @IBOutlet weak var textFieldContainer: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .woloxGreen
    }
    
    override func prepareForReuse() {
        _textField = nil
    }
    
    private func loadTextField() {
        guard let textField = _textField else { return }
        let frame = CGRect(x: textFieldContainer.frame.origin.x, y: textFieldContainer.frame.origin.y, width: textFieldContainer.frame.width, height: textFieldContainer.frame.height)
        textField.frame = frame
//        textField.frame = textFieldContainer.layer.frame
        textFieldContainer.addSubview(textField)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
