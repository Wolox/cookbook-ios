//
//  PlacesMenuViewController.swift
//  Cookbook-ios
//
//  Created by Diego Quiros on 07/04/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class PlacesMenuViewController: GeneralViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cells = PlacesExample.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        title = Features.googlePlaces.featureName
    }
}

extension PlacesMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.setUpForPlacesMenu()
        cell.textLabel?.text = cells[indexPath.row].rawValue
        return cell
    }
}

extension PlacesMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = cells[indexPath.row].controller()
        navigationController?.pushViewController(controller, animated: true)
    }
}

enum PlacesExample: String, CaseIterable {
    case fullScreen = "Full Screen Default"
    case onScreenResult = "On Screen Result Default"
    case custom = "Custom"
    
    func controller() -> GeneralViewController {
        switch self {
        case .fullScreen: return PlacesViewController(nibName: "PlacesView", bundle: nil)
        case .onScreenResult: return PlacesViewController(nibName: "PlacesView", bundle: nil)
        case .custom: return PlacesViewController(nibName: "PlacesView", bundle: nil)
        }
    }
}

fileprivate extension UITableViewCell {
    func setUpForPlacesMenu() {
        self.selectionStyle = .none
        self.backgroundColor = .woloxGreen
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
}
