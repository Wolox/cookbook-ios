//
//  GeneralViewControllerExtension.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 1/8/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class GeneralViewController: UIViewController {
    var feature: Features!
    
    func configureNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        configureInformationButton()
    }
    
    func configureInformationButton() {
        let informationButton = UIBarButtonItem.informationButton(target: self, action: #selector(showInformationView))
        navigationItem.rightBarButtonItem = informationButton
    }
    
    @objc func showInformationView() {
        let informationViewController = InformationViewController(nibName: ViewNames.informationView, bundle: nil)
        informationViewController.information = feature.information
        navigationController?.pushViewController(informationViewController, animated: true)
    }
}
