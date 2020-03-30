//
//  SocialSignInController.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 3/30/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class SocialSignInController: GeneralViewController {
    @IBOutlet weak var facebookLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feature = Features.socialSignIn
        configureNavigationBar()
    }
}
