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
    case test2
    
    var featureName: String {
        switch self {
        case .carousel: return "Carousel"
        case .codeScanner: return "Code Scanner"
        case .focusedTable: return "Focused table"
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
            return CodeScannerController(nibName: ViewNames.codeScannerView, bundle: nil)
        case .focusedTable:
            return FocusedTableController(nibName: ViewNames.focusedTableView, bundle: nil)
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
        default:
            return ""
        }
    }
    
    var information: Information {
        return Information(title: featureName,
                           content: featureConsiderations)
    }
}
