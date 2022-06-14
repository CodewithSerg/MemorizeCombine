//
//  GameViewController.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 14.05.22.
//

import SnapKit
import UIKit

final class GameViewController: UIViewController {

	private var game = GameModel()
	private var cardButtons = [UIButton]()

	private let labelCount: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = .white
		label.font = .systemFont(ofSize: 40)
		label.text = "\(Int.zero)"
		return label
	}()

	private let newGameButton: UIButton = {
		let newGameButton = UIButton(type: .system)
		newGameButton.setTitle("NEW GAME", for: .normal)
		newGameButton.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
		return newGameButton
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		makeCardButtons()
        stackedGrid()
		game.delegate = self
		self.view.backgroundColor = .blue
    }

	@objc private func resetGame() {
		game.cards = [Card]()
//		game.makeCards()
		cardButtons = [UIButton]()
		stackedGrid()
//		game.makeCards()
//		makeCardButtons()
		game.makeCards()
		makeCardButtons()
		stackedGrid()
		labelCount.text = "0"
	}

	private func stackedGrid(){
		let columns = UIScreen.main.bounds.width > UIScreen.main.bounds.width ? 6 : 4
		let rows = Int(ceil(Float(game.cards.count)/Float(columns)))

		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = 5
//		stackView.addArrangedSubview(labelCount)

		for row in 0 ..< rows {
			let horizontalSv = UIStackView()
			horizontalSv.axis = .horizontal
			horizontalSv.distribution = .fillEqually
			horizontalSv.spacing = 5

			for col in 0 ..< columns {
				let defButton = UIButton()
				defButton.alpha = 0
				horizontalSv.addArrangedSubview(cardButtons[safe: row * columns + col] ?? defButton)

			}
			stackView.addArrangedSubview(horizontalSv)
		}
//		stackView.addArrangedSubview(newGameButton)
		view.addSubview(stackView)

		// add constraints
		stackView.snp.makeConstraints {
			$0.edges.equalToSuperview().inset(5)
		}
	}

	private func makeCardButtons() {
		cardButtons = game.cards.enumerated().map{
			let button = UIButton()
			button.setTitle($1.isFaceUp ? $1.emoji : "", for: .normal)
			button.titleLabel?.font = .systemFont(ofSize: 40)
			button.layer.cornerRadius = 5
			button.backgroundColor = .orange
			// add tag to identify at array
			button.tag = $0
			button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
			return button
		}
	}

	@objc private func buttonTapped(button: UIButton) {
		game.buttonTapped(tag: button.tag)
	}
}

extension GameViewController: GameDelegate {
	func flipCards(cards: [Int]) {
		cards.forEach {cardButtons[$0].setTitle(game.cards[$0].isFaceUp ? game.cards[$0].emoji : "", for: .normal)}
	}

	func removeMatchedCards(cards: [Int]) {
		cards.forEach {cardButtons[$0].alpha = 0}
	}

	func changeCount(count: Int) {
		labelCount.text = String(count)
	}
}




