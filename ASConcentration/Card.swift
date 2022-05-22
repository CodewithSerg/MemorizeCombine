//
//  Card.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 22.05.22.
//

import Foundation

struct Card: Hashable {
    let id = UUID()
    let emoji:String
    var isFaceUp = false
    var isMatched = false
}
