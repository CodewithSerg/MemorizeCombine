//
//  ViewModel.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 22.05.22.
//

import Foundation
import UIKit
import Combine

// MARK: - GameDelegate

//protocol GameDelegate: AnyObject {
//	func removeMatchedCards(cards: [Int])
//	func flipCards(cards: [Int])
//	func flipCard(cardIndex: Int)
//	func changeCount(count: Int)
//}

// MARK: - GameModelProtocol

protocol GameModelProtocol {
//	var cards: [Card] { get }
//	var delegate: GameDelegate? { get set }
//	func buttonTapped(tag: Int)
//	func newGameScreen()
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
//	weak var delegate: GameDelegate?
	private var choosenTags = [Int]()
//	private var countResult = 0 {
//		didSet {
//			delegate?.changeCount(count: countResult)
//		}
//	}
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
		if choosenTags.contains(tag) {
//			countResult -= 1 // to count result
		}
		choosenTags.append(tag)

		inMemoryCards.append(tag)
		if inMemoryCards.count == 2,
		   let first = inMemoryCards.first,
		   cards[first].emoji == cards[tag].emoji,
		   first != tag {
			cards[tag].isFaceUp.toggle()
//			delegate?.flipCard(cardIndex: tag)
			inMemoryCards.forEach { cards[$0].isMatched = true}
//			delegate?.removeMatchedCards(cards: inMemoryCards)
//			countResult += 2 // to count result
			inMemoryCards = [Int]()
		} else if inMemoryCards.count > 2 {
			inMemoryCards.forEach { cards[$0].isFaceUp.toggle() }
//			delegate?.flipCards(cards: inMemoryCards)

			inMemoryCards = [tag]
		} else {
			cards[tag].isFaceUp.toggle()
//			delegate?.flipCard(cardIndex: tag)

		}
		inputVC.send(.redrawCards(cards: cards))
	}

	private func newGameScreen() {
		guard
			let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
		else { return }
		let gameModel = GameModel()
		let screen = GameViewController(model: gameModel)
		sceneDelegate.window?.rootViewController = screen
		sceneDelegate.window?.makeKeyAndVisible()
	}

	private func makeNewGame() {
		cards = [Card]()
		choosenTags = [Int]()
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
