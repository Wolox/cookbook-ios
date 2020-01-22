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
    case test
    
    var featureName: String {
        switch self {
        case .carousel: return "Carousel"
        case .codeScanner: return "Code Scanner"
        case .test: return "Test"
        }
    }
    
    var featureImage: UIImage {
        switch self {
        case .carousel: return  UIImage()
        case .codeScanner: return UIImage.scannerImage
        case .test: return UIImage()
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
        }
    }
    
    var information: Information {
        return Information(title: featureName,
                           content: featureConsiderations)
    }
}
