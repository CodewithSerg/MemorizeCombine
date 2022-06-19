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

protocol GameModelProtocol {
	
}

final class GameModel {

	private var emojies = ["🐶","🦋","🐰","🐝","🐽","🐸","🍏"]
	var cards = [Card]()
	weak var delegate: GameDelegate?

	var choosenTags = [Int]()
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
		emojies.forEach {
			cards.append(contentsOf: [Card(emoji: $0), Card(emoji: $0)])
		}
		cards.shuffle()
	}

	func buttonTapped(tag: Int) {
		inMemoryCards.append(tag)
		if choosenTags.contains(tag) {
			countResult -= 1 // to count result
		}
		choosenTags.append(tag)
		if inMemoryCards.count == 2,
		   let first = inMemoryCards.first,
		   cards[first].emoji == cards[tag].emoji,
		   first != tag
		{
			cards[tag].isFaceUp.toggle()
			delegate?.flipCards(cards: [tag])
			
			inMemoryCards.forEach { cards[$0].isMatched = true}
			delegate?.removeMatchedCards(cards: inMemoryCards)
			countResult += 2 // to count result
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

	func newGameScreen() {
		guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
		let screen = GameViewController()
		sceneDelegate.window?.rootViewController = screen
		sceneDelegate.window?.makeKeyAndVisible()
	}
}


