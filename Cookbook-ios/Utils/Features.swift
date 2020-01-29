//
//  Features.swift
//  Cookbook-ios
//
//  Created by Carolina Arcos on 1/8/20.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

enum Features: CaseIterable {
    case carousel
    case codeScanner
    case textFields
    case test
    
    var featureName: String {
        switch self {
        case .carousel: return "Carousel"
        case .codeScanner: return "Code Scanner"
        case .test: return "Test"
        case .textFields: return "Text Fields"
        }
    }
    
    var featureImage: UIImage {
        switch self {
        case .carousel: return  UIImage()
        case .codeScanner: return UIImage.scannerImage
        case .test: return UIImage()
        case .textFields: return UIImage.textImage
        }
    }
    
    var viewController: GeneralViewController  {
        switch self {
        case .carousel:
            return CarouselViewController(nibName: ViewNames.carouselView, bundle: nil)
        case .codeScanner:
            return CarouselViewController(nibName: ViewNames.carouselView, bundle: nil)
        case .test:
            return GeneralViewController()
        case .textFields:
            return TextFieldsViewController(nibName: ViewNames.textFields, bundle: nil)
        }
    }
    
    var featureConsiderations: String {
        switch self {
        case .carousel:
            return """
            - In this example the focused item is centered, but this behaviour can be removed and the carousel will stop in the position the user sets.
            
            - Cell's content and it's size can be modified based on design.
            """
        case .codeScanner:
            return ""
        case .test:
            return ""
        case .textFields:
            return ""
        }
    }
    
    var information: Information {
        return Information(title: featureName,
                           content: featureConsiderations)
    }
}
