//
//  ViewModel.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 22.05.22.
//

import Foundation
import UIKit

// MARK: - GameDelegate

protocol GameDelegate: AnyObject {
	func removeMatchedCards(cards: [Int])
	func flipCards(cards: [Int])
	func flipCard(cardIndex: Int)
	func changeCount(count: Int)
}

// MARK: - GameModelProtocol

protocol GameModelProtocol {
	var cards: [Card] { get set }
	var delegate: GameDelegate? { get set }

	func buttonTapped(tag: Int)
	func newGameScreen()
}

final class GameModel: GameModelProtocol {

	private var emojies = ["🐶", "🦋", "🐰", "🐝", "🐽", "🐸", "🍏"]
	weak var delegate: GameDelegate?
	private var choosenTags = [Int]()
	private var countResult = 0 {
		didSet {
			delegate?.changeCount(count: countResult)
		}
	}
	private var inMemoryCards = [Int]() // 0...3 card
	var cards = [Card]()

	init() {
		makeCards()
    }

	func buttonTapped(tag: Int) {
		if choosenTags.contains(tag) {
			countResult -= 1 // to count result
		}
		choosenTags.append(tag)

		inMemoryCards.append(tag)
		if inMemoryCards.count == 2,
		   let first = inMemoryCards.first,
		   cards[first].emoji == cards[tag].emoji,
		   first != tag {
			cards[tag].isFaceUp.toggle()
			delegate?.flipCard(cardIndex: tag)

			inMemoryCards.forEach { cards[$0].isMatched = true}
			delegate?.removeMatchedCards(cards: inMemoryCards)
			countResult += 2 // to count result
			inMemoryCards = [Int]()
		} else if inMemoryCards.count > 2 {
			inMemoryCards.forEach { cards[$0].isFaceUp.toggle() }
			delegate?.flipCards(cards: inMemoryCards)
			inMemoryCards = [tag]
		} else {
			cards[tag].isFaceUp.toggle()
			delegate?.flipCard(cardIndex: tag)
		}
	}

	func newGameScreen() {
		guard
			let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
		else { return }
		let screen = GameViewController()
		sceneDelegate.window?.rootViewController = screen
		sceneDelegate.window?.makeKeyAndVisible()
	}

	private func makeCards() {
		emojies.forEach {
			cards.append(contentsOf: [Card(emoji: $0), Card(emoji: $0)])
		}
		cards.shuffle()
	}
}
