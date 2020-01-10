//
//  InformationViewController.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 1/8/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    var information: Information!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = information.title
        contentLabel.text = information.content
    }
}
