//
//  TextFieldsTableViewCell.swift
//  Cookbook-ios
//
//  Created by Matias Schwalb on 29/01/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class TextFieldsTableViewCell: UITableViewCell {

    @IBOutlet weak var testLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
