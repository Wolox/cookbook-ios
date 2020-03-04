//
//  ShadowViewController.swift
//  Cookbook-ios
//
//  Created by Daniel Andres Charry on 04/03/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class ShadowViewController: GeneralViewController {
    
    @IBOutlet weak var prueba1: UIView!
    
    @IBOutlet weak var prueba2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
}

extension ShadowViewController {
    func setUpUI() {
        prueba1.applyShadow()
        prueba2.applyShadow(color: UIColor.red.cgColor)
    }
}
