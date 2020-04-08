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
        _textFieldsArray.append(yoshiko)
        // Hoshi
        let hoshi = HoshiTextField()
        _textFieldsArray.append(hoshi)
        // Minoru
        let minoru = MinoruTextField()
        _textFieldsArray.append(minoru)
        // Yoko
        let yoko = YokoTextField()
        _textFieldsArray.append(yoko)
        // Jiro
        let jiro = JiroTextField()
        _textFieldsArray.append(jiro)
        // Madoka
        let madoka = MadokaTextField()
        _textFieldsArray.append(madoka)
        // Kaede
        let kaede = KaedeTextField()
        _textFieldsArray.append(kaede)
        // Akira
        let akira = AkiraTextField()
        _textFieldsArray.append(akira)
        // Isao
        let isao = IsaoTextField()
        _textFieldsArray.append(isao)

        return _textFieldsArray
    }()
}
