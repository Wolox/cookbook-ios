//
//  PlacesViewController.swift
//  Cookbook-ios
//
//  Created by Diego Quiros on 06/04/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit
import GooglePlaces

// For more information visit the places developers documentation at
//https://developers.google.com/places/ios-sdk/autocomplete#add_an_autocomplete_ui_control

class PlacesViewController: GeneralViewController {
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBAction func onSelectPlacePressed(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
          UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension PlacesViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.placeLabel.text = place.name
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("an error ocurred with google maps, check if your app reached the request limit")
        dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
}
