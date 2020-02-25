//
//  Chip.swift
//  Cookbook-ios
//
//  Created by Matías Spinelli on 24/02/2020.
//  Copyright © 2020 Wolox. All rights reserved.
//

import UIKit

struct Chip: Equatable {
    var id: Int
    var type: String
    var name: String
}

func == (lhs: Chip, rhs: Chip) -> Bool {
    return lhs.id == rhs.id
}
