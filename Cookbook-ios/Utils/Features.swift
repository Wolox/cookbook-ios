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
    case focusedTable
    case shadow
    case test
    
    var featureName: String {
        switch self {
        case .carousel: return "Carousel"
        case .codeScanner: return "Code Scanner"
        case .focusedTable: return "Focused table"
        case .shadow: return "Shadow View"
        case .test: return "Test"
        }
    }
    
    var featureImage: UIImage {
        switch self {
        case .carousel: return  UIImage()
        case .codeScanner: return UIImage.scannerImage
        case .focusedTable: return UIImage.focusedImage
        case .shadow: return UIImage.shadowImage
        default: return UIImage()
        }
    }
    
    var viewController: GeneralViewController  {
        switch self {
        case .carousel:
            return CarouselViewController(nibName: ViewNames.carouselView, bundle: nil)
        case .codeScanner:
            return CodeScannerController(nibName: ViewNames.codeScannerView, bundle: nil)
        case .focusedTable:
            return FocusedCollectionController(nibName: ViewNames.focusedCollectionView, bundle: nil)
            return CarouselViewController(nibName: ViewNames.carouselView, bundle: nil)
        case .shadow:
            return ShadowViewController(nibName: ViewNames.shadowView, bundle: nil)
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
        case .codeScanner:
            return """
            - Type of codes to scan can be one or more of these options:
                - aztec
                - code128
                - code39
                - code39Mod43
                - code93
                - dataMatrix
                - ean13
                - ean8
                - interleaved2of5
                - itf14
                - pdf417
                - qr
                - upce
            
            - We validate if the user has camera and if he/she has accepted the access permission.
            
            - Alert messages and actions can be modified
            """
        case .focusedTable:
            return """
            - Focused item will be always at the top
            
            - Attributes that can be modified:
                - Cell content
                - Cell height and growth rate
                - Growth and color rate of cell content
                - Action when tapping a cell
            
            Note: it looks like a table but it's not
            """
        case .shadow:
            return """
            - You can move the sliders to modify the shadow attributes

            Attributes that can be modified:
            - Shadow radius
            - Shadow size
            - Shadow opacity
            - Corner radius
            - Shadow colors (one at a time)

            - At the end a circle with an example shadow
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
