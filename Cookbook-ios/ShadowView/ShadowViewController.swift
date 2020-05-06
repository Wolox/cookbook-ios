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
    
    @IBOutlet weak var prueba3: UIView!
    
    @IBOutlet weak var slideRadius: UISlider!
    @IBOutlet weak var slideSize: UISlider!
    @IBOutlet weak var slideOpacity: UISlider!
    @IBOutlet weak var slideCornerRadius: UISlider!
    
    @IBOutlet weak var colorContainer: UIStackView!
    
    private var size: CGSize?
    private var radius: CGFloat?
    private var opacity: Float?
    private var cornerRadius: CGFloat?
    private var color: CGColor?
    
    private var colorPrevio = [UIColor.red, UIColor.black, UIColor.blue, UIColor.yellow, UIColor.green, UIColor.orange]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        createColors()
    }
    
    @IBAction func sliderRadiusChanged(_ sender: Any) {
        radius = CGFloat(slideRadius.value * 2)
        prueba1.applyShadow(color: color, size: size, radius: radius, opacity: opacity, cornerRadius: cornerRadius)
        
    }
    @IBAction func sliderSizeChanged(_ sender: Any) {
        var w = Int(slideSize.value * -100)
        var h = Int(slideSize.value * 100)
        size = CGSize(width: w, height: h)
        prueba1.applyShadow(color: color, size: size, radius: radius, opacity: opacity, cornerRadius: cornerRadius)
    }
    
    @IBAction func sliderOpacityChanged(_ sender: Any) {
        opacity = Float(slideOpacity.value)
        prueba1.applyShadow(color: color, size: size, radius: radius, opacity: opacity, cornerRadius: cornerRadius)
    }
    
    @IBAction func sliderCornerRadiusChanged(_ sender: Any) {
        cornerRadius = CGFloat(slideCornerRadius.value * 60)
        prueba1.applyShadow(color: color, size: size, radius: radius, opacity: opacity, cornerRadius: cornerRadius)
    }
    
    
    
}

extension ShadowViewController {
    func setUpUI() {
        
        prueba1.applyShadow()

        prueba3.applyShadow(color: UIColor.red.cgColor, cornerRadius: prueba3.frame.width / 2)
    }
    
    func createColors() {
        colorContainer.arrangedSubviews.enumerated().forEach {
            $0.element.backgroundColor = colorPrevio[$0.offset]
        }
    }
    
    func gestureTap() {
//        let tap = UIGestureRecognizer(target: self, action: #selector(han))
//        colorContainer.arrangedSubviews[0].addGestureRecognizer(tap)
    }
}
