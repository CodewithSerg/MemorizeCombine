//
//  GameViewController.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 14.05.22.
//

// MVVM -> Корневой экран, swinject, модуль статистики. Лучшее время, лучший результат, последние 5 результатов,
// TODO: Realm -> RealmManager, R.generated -> Локализация, цвета чтобы в темной и светлой теме норм работали
// TODO: Таймер добавить
// По желанию: почитать лекцию, глянуть анимацию переворота карты

import SnapKit
import UIKit
import Combine


final class GameViewController: UIViewController {

	private var game: GameModelProtocol
	private var cardButtons = [UIButton]()

	private let outputVC = PassthroughSubject<GameModel.Output, Never>()
	private var bag = Set<AnyCancellable>()

	private let labelCount: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = .white
		label.font = .systemFont(ofSize: 40)
		label.text = "Timer : \(Int.zero)"
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
		newGameButton.setTitle(GameVC.newGameTitle.localized, for: .normal)
		newGameButton.addTarget(self, action: #selector(resetGame), for: .touchUpInside)
		return newGameButton
	}()

	init(model: GameModelProtocol) {
		self.game = model
		super.init(nibName: nil, bundle: nil)
	}

	@available (*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
		view.backgroundColor = .blue
		bind()
		outputVC.send(.viewLoaded)
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		outputVC.send(.startTimer)
	}

	private func bind() { //configureIO
		let input = game.transform(outputVC: outputVC.eraseToAnyPublisher())
		input
			.receive(on: DispatchQueue.main)
			.sink { [weak self] event in
				switch event {
				case .makeCards(cards: let cards):
					self?.stackedGrid(cards: cards)
				case .redrawCards(cards: let cards):
					self?.redrawCardButtons(cards: cards)
				case .makeNewCards(cards: let cards):
					self?.makeNewCards(cards: cards)
				case .timerCount(count: let count):
					self?.labelCount.text =  count
				}
			}
			.store(in: &bag)
	}

	private func redrawCardButtons(cards: [Card]) {
		cards.enumerated().forEach {
			cardButtons[$0].setTitle($1.isFaceUp ? $1.emoji : "", for: .normal)

			let cardButton = cardButtons[$0]
			if $1.isMatched {
				UIView.animate(withDuration: 1) {
					cardButton.alpha = 0
				}
			}
		}
	}

	private func makeNewCards(cards: [Card]) {
		cardButtons.forEach {
			$0.setTitle("", for: .normal)
			$0.alpha = 1
		}
	}

	private func stackedGrid(cards: [Card]) {
		let columns = UIScreen.main.bounds.width > UIScreen.main.bounds.width ? 6 : 4
		let rows = Int(ceil(Float(cards.count) / Float(columns)))

		for row in 0 ..< rows {
			let horizontalSv = UIStackView()
			horizontalSv.axis = .horizontal
			horizontalSv.distribution = .fillEqually
			horizontalSv.spacing = 5

			for col in 0 ..< columns {
				let indexCard = row * columns + col
				horizontalSv.addArrangedSubview(makeCardButton(card: cards[safe: indexCard], indexCard: indexCard) ?? UIButton())
			}
			stackView.addArrangedSubview(horizontalSv)
		}
	}

	private func setupView() {
		view.addSubview(labelCount)
		view.addSubview(stackView)
		view.addSubview(newGameButton)

		labelCount.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
			$0.leading.trailing.equalToSuperview().inset(24)
			$0.centerX.equalToSuperview()
		}
		stackView.snp.makeConstraints {
			$0.top.equalTo(labelCount.snp.bottom)
			$0.height.equalToSuperview().multipliedBy(0.66)
			$0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(8)
			$0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(8)
		}
		newGameButton.snp.makeConstraints {
			$0.top.equalTo(stackView.snp.bottom).offset(16)
			$0.centerX.equalToSuperview()
			$0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
			$0.height.equalTo(40)
		}
	}

	private func makeCardButton(card: Card?, indexCard: Int) -> UIButton? {
		guard let card = card else { return nil }
		let button = UIButton()
		button.setTitle(card.isFaceUp ? card.emoji : "", for: .normal)
		button.titleLabel?.font = .systemFont(ofSize: 40)
		button.layer.cornerRadius = 5
		button.backgroundColor = .orange
		button.tag = indexCard
		button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
		cardButtons.append(button)
		return button
	}


	@objc private func buttonTapped(button: UIButton) {
		outputVC.send(.cardTapped(tag: button.tag))
	}

	@objc private func resetGame() {
//		game.newGameScreen()
		outputVC.send(.newGameTapped)
	}
}
