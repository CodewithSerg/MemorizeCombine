//
//  MainViewController.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 17.07.22.
//

import UIKit

class MainViewController: UIViewController, Coordinating {

	var coordinator: Coordinator?
	var vm = MainViewModel()

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
		newGameButton.addTarget(self, action: #selector(newGameTapped), for: .touchUpInside)
		return newGameButton
	}()

	private let statisticGameButton: UIButton = {
		let newGameButton = UIButton(type: .system)
		newGameButton.setTitle("Game Statistic", for: .normal)
		newGameButton.addTarget(self, action: #selector(statisticGameTapped), for: .touchUpInside)
		return newGameButton
	}()

	@objc func newGameTapped() {
		coordinator?.eventOccured(with: .startGameButtonTapped)
	}

	@objc func statisticGameTapped() {
		coordinator?.eventOccured(with: .statisticButtonTapped)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
    }

	private func setupView() {
		view.addSubview(stackView)
		stackView.addArrangedSubview(newGameButton)
		stackView.addArrangedSubview(statisticGameButton)
		stackView.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.centerY.equalToSuperview()
			$0.width.equalToSuperview()
		}
	}
}
