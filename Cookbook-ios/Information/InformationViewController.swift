//
//  InformationViewController.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 1/8/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController {
    @IBOutlet weak var contentLabel: UITextView!
    
    var information: Information!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = information.title
        contentLabel.text = information.content
    }
}
