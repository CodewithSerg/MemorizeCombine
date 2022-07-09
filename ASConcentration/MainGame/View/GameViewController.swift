//
//  GameViewController.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 14.05.22.
//

import SnapKit
import UIKit

final class GameViewController: UIViewController {

	private var game: GameModelProtocol
	private var cardButtons = [UIButton]()

	private let labelCount: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = .white
		label.font = .systemFont(ofSize: 40)
		label.text = "\(Int.zero)"
		return label
	}()

	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.spacing = 5
		return stackView
	}()

	private let newGameButton: UIButton = {
		let newGameButton = UIButton(type: .system)
		newGameButton.setTitle("NEW GAME", for: .normal)
		newGameButton.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
		return newGameButton
	}()

	init() {
		game = GameModel()
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		makeCardButtons()
        stackedGrid()
		setupView()
		game.delegate = self
		self.view.backgroundColor = .blue
    }

	private func stackedGrid() {
		let columns = UIScreen.main.bounds.width > UIScreen.main.bounds.width ? 6 : 4
		let rows = Int(ceil(Float(game.cards.count) / Float(columns)))

		for row in 0 ..< rows {
			let horizontalSv = UIStackView()
			horizontalSv.axis = .horizontal
			horizontalSv.distribution = .fillEqually
			horizontalSv.spacing = 5

			for col in 0 ..< columns {
				let makeFullRawButton = UIButton()
				makeFullRawButton.alpha = 0
				horizontalSv.addArrangedSubview(cardButtons[safe: row * columns + col] ?? makeFullRawButton)

			}
			stackView.addArrangedSubview(horizontalSv)
		}
	}

	private func setupView() {
		view.addSubview(labelCount)
		view.addSubview(stackView)
		view.addSubview(newGameButton)

		labelCount.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
			$0.leading.trailing.equalToSuperview().inset(24)
			$0.centerX.equalToSuperview()
		}

		stackView.snp.makeConstraints {
			$0.top.equalTo(labelCount.snp.bottom)
			$0.height.equalToSuperview().multipliedBy(0.66)
			$0.leading.trailing.equalToSuperview().inset(5)
		}

		newGameButton.snp.makeConstraints {
			$0.top.equalTo(stackView.snp.bottom).offset(16)
			$0.centerX.equalToSuperview()
			$0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
		}
	}

	private func makeCardButtons() {
		cardButtons = game.cards.enumerated().map{
			let button = UIButton()
			button.setTitle($1.isFaceUp ? $1.emoji : "", for: .normal)
			button.titleLabel?.font = .systemFont(ofSize: 40)
			button.layer.cornerRadius = 5
			button.backgroundColor = .orange
			button.tag = $0
			button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
			return button
		}
	}

	@objc private func buttonTapped(button: UIButton) {
		game.buttonTapped(tag: button.tag)
	}
	@objc private func resetGame() {
		game.newGameScreen()
	}
}

// MARK: - GameDelegate

extension GameViewController: GameDelegate {
	func flipCard(cardIndex: Int) {
		UIView.animate(withDuration: 1) {
			self.cardButtons[cardIndex].alpha = 0
		}
		cardButtons[cardIndex].setTitle(game.cards[cardIndex].isFaceUp ? game.cards[cardIndex].emoji : "", for: .normal)
		UIView.animate(withDuration: 1) {
			self.cardButtons[cardIndex].alpha = 1
		}
	}

	func flipCards(cards: [Int]) {
		UIView.animate(withDuration: 1) {
			cards.forEach { self.cardButtons[$0].alpha = 0 }
		}
		cards.forEach {
			cardButtons[$0].setTitle(game.cards[$0].isFaceUp ? game.cards[$0].emoji : "", for: .normal)
		}
		UIView.animate(withDuration: 1) {
			cards.forEach { self.cardButtons[$0].alpha = 1 }
		}

	}

	func removeMatchedCards(cards: [Int]) {
		UIView.animate(withDuration: 1) {
			cards.forEach { self.cardButtons[$0].alpha = 0 }
		}
	}

	func changeCount(count: Int) {
		labelCount.text = "\(count)"
	}
}




