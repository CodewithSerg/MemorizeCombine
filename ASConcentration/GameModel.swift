//
//  ViewModel.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 22.05.22.
//

import Foundation
import UIKit

protocol GameDelegate: AnyObject {
	func removeMatchedCards(cards: [Int])
	func flipCards(cards: [Int])
	func changeCount(count: Int)
}

final class GameModel {

	private var resourses2 = [ "🐶","🦋","🐰","🐝","🐽","🐸","🍏"]
	private var emojies = [String]()
	var cards = [Card]()
	weak var delegate: GameDelegate?

	var choosenTags = [Int]()
//	var choosenCards = [Card]()
	var countResult = 0 {
		didSet {
			delegate?.changeCount(count: countResult)
		}
	}
	private var inMemoryCards = [Int]() // 0...3 card

	init() {
		makeCards()
    }

	func makeCards() {
		emojies = resourses2 + resourses2
		emojies.shuffle()
		cards = emojies.map{
			Card(emoji: $0)
		}
	}

	func buttonTapped(tag: Int) {
		inMemoryCards.append(tag)
		if choosenTags.contains(tag) {
			countResult -= 1
		}
		choosenTags.append(tag)
		if inMemoryCards.count == 2,
		   let first = inMemoryCards.first,
		   cards[first].emoji == cards[tag].emoji,
		   first != tag
		{
			inMemoryCards.forEach { cards[$0].isMatched = true}
			delegate?.removeMatchedCards(cards: inMemoryCards)
			countResult += 2
			inMemoryCards = [Int]()
			return
		}
		if inMemoryCards.count > 2 {
			inMemoryCards.forEach { cards[$0].isFaceUp.toggle()}
			delegate?.flipCards(cards: inMemoryCards)
			inMemoryCards = [tag]
			return
		}
		cards[tag].isFaceUp.toggle()
		delegate?.flipCards(cards: [tag])
	}
}

extension Collection {
	subscript (safe index: Index) -> Element? {
		indices.contains(index) ? self[index] : nil
	}
}
