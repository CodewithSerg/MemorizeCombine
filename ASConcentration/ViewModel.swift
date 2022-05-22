//
//  ViewModel.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 22.05.22.
//

import Foundation

class ViewModel {

    var resourses2 = [ "🐶","🦋","🐰","🐝","🐽","🐸","🍏"]
    var cards = [Card]()
    var emojies = [String]()

    init() {
        emojies = resourses2 + resourses2
        emojies.shuffle()
    }

    var indexOfOneFacedUp: Int? {
        get {
            let facedUpIndexes = cards.indices.filter { cards[$0].isFaceUp }
            return facedUpIndexes.count == 1 ? facedUpIndexes.first : nil
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }

    func chooseCard(index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneFacedUp, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneFacedUp = index
            }
        }
    }
}
