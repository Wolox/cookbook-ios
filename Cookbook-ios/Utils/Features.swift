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
    case test2
    
    var featureName: String {
        switch self {
        case .carousel: return "Carousel"
        case .codeScanner: return "Code Scanner"
        case .test: return "Test"
        case .test2: return "Test 2"
        }
    }
    
    var featureImage: UIImage {
        switch self {
        case .carousel: return  UIImage()
        case .codeScanner: return UIImage.scannerImage
        default: return UIImage()
        }
    }
    
    var viewController: GeneralViewController  {
        switch self {
        case .carousel:
            return CarouselViewController(nibName: ViewNames.carouselView, bundle: nil)
        case .codeScanner:
            return CarouselViewController(nibName: ViewNames.carouselView, bundle: nil)
        default:
            return GeneralViewController()
        }
    }
    
    var featureConsiderations: String {
        switch self {
        case .carousel:
            return """
            - Selected item will be always centered
            
            - Attributes that can be modified:
                - Cell size (width and/or height)
                - Distance between cells
                - Side cell alpha
                - Side cell scale
                - Scroll direction
            """
        default:
            return ""
        }
    }
    
    var information: Information {
        return Information(title: featureName,
                           content: featureConsiderations)
    }
}
