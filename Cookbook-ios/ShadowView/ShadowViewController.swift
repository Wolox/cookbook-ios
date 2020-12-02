//
//  ShadowViewController.swift
//  Cookbook-ios
//
//  Created by Daniel Andres Charry on 04/03/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class ShadowViewController: GeneralViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var testRectangelView: UIView!
    @IBOutlet weak var testCircleView: UIView!
    @IBOutlet weak var slideRadius: UISlider!
    @IBOutlet weak var slideSize: UISlider!
    @IBOutlet weak var slideOpacity: UISlider!
    @IBOutlet weak var slideCornerRadius: UISlider!
    @IBOutlet weak var colorFirst: UIButton!
    @IBOutlet weak var colorSecond: UIButton!
    @IBOutlet weak var colorThird: UIButton!
    
    @IBAction func sliderRadiusChanged(_ sender: Any) {
        radius = CGFloat(slideRadius.value * 2)
        testRectangelView.applyShadow(color: selectColor?.cgColor,
                                      size: size,
                                      radius: radius,
                                      opacity: opacity,
                                      cornerRadius: cornerRadius)
        
    }
    
    @IBAction func sliderSizeChanged(_ sender: Any) {
        let width = Int(slideSize.value * -10)
        let height = Int(slideSize.value * 10)
        size = CGSize(width: width, height: height)
        testRectangelView.applyShadow(color: selectColor?.cgColor,
                                      size: size,
                                      radius: radius,
                                      opacity: opacity,
                                      cornerRadius: cornerRadius)
    }
    
    @IBAction func sliderOpacityChanged(_ sender: Any) {
        opacity = Float(slideOpacity.value)
        testRectangelView.applyShadow(color: selectColor?.cgColor,
                                      size: size,
                                      radius: radius,
                                      opacity: opacity,
                                      cornerRadius: cornerRadius)
    }
    
    @IBAction func sliderCornerRadiusChanged(_ sender: Any) {
        cornerRadius = CGFloat(slideCornerRadius.value * 60)
        testRectangelView.applyShadow(color: selectColor?.cgColor,
                                      size: size, radius: radius,
                                      opacity: opacity,
                                      cornerRadius: cornerRadius)
    }
    
    @IBAction func pressFirstButtonChangedColor(_ sender: Any) {
        selectColor = UIColor.black
        testRectangelView.applyShadow(color: selectColor?.cgColor,
                                      size: size,
                                      radius: radius,
                                      opacity: opacity,
                                      cornerRadius: cornerRadius)
    }
    
    @IBAction func pressSecondButtonChangeColor(_ sender: Any) {
        selectColor = UIColor.red
        testRectangelView.applyShadow(color: selectColor?.cgColor,
                                      size: size,
                                      radius: radius,
                                      opacity: opacity,
                                      cornerRadius: cornerRadius)
    }
    
    @IBAction func pressThirdButtonChangeColor(_ sender: Any) {
        selectColor = UIColor.yellow
        testRectangelView.applyShadow(color: selectColor?.cgColor,
                                      size: size,
                                      radius: radius,
                                      opacity: opacity,
                                      cornerRadius: cornerRadius)
    }
    
    // MARK: - Private vars
    private var size: CGSize?
    private var radius: CGFloat?
    private var opacity: Float?
    private var cornerRadius: CGFloat?
    private var selectColor: UIColor?
    private var color: CGColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feature = .shadow
        configureNavigationBar()
        setUpUI()
    }
}

extension ShadowViewController {
    func setUpUI() {
        testRectangelView.applyShadow()
        testCircleView.applyShadow(color: UIColor.red.cgColor,
                                   cornerRadius: testCircleView.frame.width / 2)
    }
}
