//
//  TextFields.swift
//  Cookbook-ios
//
//  Created by Matias David Schwalb on 08/04/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

class TextFields {
    static let textFieldsArray: [TextFieldEffects] = {
        var _textFieldsArray: [TextFieldEffects] = []
        
        // Yoshiko
        let yoshiko = YoshikoTextField()
        yoshiko.name = "Yoshiko"
        yoshiko.activeBackgroundColor = .white
        yoshiko.activeBorderColor = .purple
        yoshiko.placeholderColor = .darkGray
        yoshiko.inactiveBorderColor = .lightGray
        yoshiko.placeholder = "Yoshiko"
        _textFieldsArray.append(yoshiko)
        // Hoshi
        let hoshi = HoshiTextField()
        hoshi.name = "Hoshi"
        hoshi.placeholderColor = .darkGray
        hoshi.borderActiveColor = .red
        hoshi.borderInactiveColor = .blue
        hoshi.placeholder = "Hoshi"
        _textFieldsArray.append(hoshi)
        // Minoru
        let minoru = MinoruTextField()
        minoru.name = "Minoru"
        minoru.placeholderColor = .darkGray
        minoru.textColor = .woloxGreen
        minoru.placeholder = "Minoru"
        _textFieldsArray.append(minoru)
        // Yoko
        let yoko = YokoTextField()
        yoko.name = "Yoko"
        yoko.foregroundColor = .lightGray
        yoko.placeholderColor = .darkGray
        yoko.textColor = .white
        yoko.placeholder = "Yoko"
        _textFieldsArray.append(yoko)
        // Jiro
        let jiro = JiroTextField()
        jiro.name = "Jiro"
        jiro.placeholderColor = .navyBlue
        jiro.textColor = .white
        jiro.borderColor = .navyBlue
        jiro.placeholder = "Jiro"
        _textFieldsArray.append(jiro)
        // Madoka
        let madoka = MadokaTextField()
        madoka.name = "Madoka"
        madoka.placeholderColor = .darkGray
        madoka.borderColor = .red
        madoka.placeholder = "Madoka"
        _textFieldsArray.append(madoka)
        // Kaede
        let kaede = KaedeTextField()
        kaede.name = "Kaede"
        _textFieldsArray.append(kaede)
        // Akira
        let akira = AkiraTextField()
        akira.name = "Akira"
        _textFieldsArray.append(akira)
        // Isao
        let isao = IsaoTextField()
        isao.name = "Isao"
        _textFieldsArray.append(isao)

        return _textFieldsArray
    }()
}

