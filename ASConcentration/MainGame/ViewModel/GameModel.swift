//
//  ViewModel.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 22.05.22.
//

import Foundation
import UIKit
import Combine

protocol GameModelProtocol {
	func transform(outputVC: AnyPublisher<GameModel.Output, Never>) -> AnyPublisher<GameModel.Input, Never>
}

final class GameModel: GameModelProtocol {

	enum Output {
		case viewLoaded
		case startTimer
		case cardTapped(tag: Int)
		case newGameTapped
	}

	enum Input {
//		case flipCard(card: Card)
//		case removeMatchedCards(cards: [Int])
		case redrawCards(cards: [Card])
		case makeCards(cards: [Card])
		case timerCount(count: Int)
		case makeNewCards(cards: [Card])
	}

	private var emojies = ["🐶", "🦋", "🐰", "🐝", "🐽", "🐸", "🍏"]

	private var timerCount: Int = 0 {
		didSet {
			inputVC.send(.timerCount(count: timerCount))
		}
	}
	private var inMemoryCards = [Int]() // 0...3 card
	private var cards = [Card]()
	private let inputVC = PassthroughSubject<GameModel.Input, Never>()
	private var bag = Set<AnyCancellable>()

	init() {
		makeCards()
    }

	func transform(outputVC: AnyPublisher<Output, Never>) -> AnyPublisher<Input, Never> {
		outputVC.sink { [weak self] event in
			guard let self = self else { return }
			switch event {
			case .viewLoaded:
				self.inputVC.send(.makeCards(cards: self.cards))
			case .cardTapped(tag: let num):
				self.buttonTapped(tag: num)
			case .newGameTapped:
//				self.newGameScreen()
				self.makeNewGame()
			case .startTimer:
				self.startTimer()
			}
	   }.store(in: &bag)
	   return inputVC.eraseToAnyPublisher()
	 }

	private func buttonTapped(tag: Int) {
		inMemoryCards.append(tag)
		if inMemoryCards.count == 2,
		   let first = inMemoryCards.first,
		   cards[first].emoji == cards[tag].emoji,
		   first != tag {
			cards[tag].isFaceUp.toggle()
			inMemoryCards.forEach { cards[$0].isMatched = true}
			inMemoryCards = [Int]()
		} else if inMemoryCards.count > 2 {
			inMemoryCards.forEach { cards[$0].isFaceUp.toggle() }
			inMemoryCards = [tag]
		} else {
			cards[tag].isFaceUp.toggle()
		}
		inputVC.send(.redrawCards(cards: cards))
	}

	private func makeNewGame() {
		cards = [Card]()
		inMemoryCards = [Int]()
		makeCards()
		inputVC.send(.makeNewCards(cards: cards))
		timerCount = 0
	}

	private func startTimer() {
		Timer.publish(every: 1, on: .main, in: .default)
			.autoconnect()
			.sink { [weak self] _ in
				self?.timerCount += 1
			}
			.store(in: &bag)
	}

	private func makeCards() {
		emojies.forEach {
			cards.append(contentsOf: [Card(emoji: $0), Card(emoji: $0)])
		}
		cards.shuffle()
	}
}
