//
//  AppCoordinator.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 16.07.22.
//

import UIKit

enum Event {
	case statisticButtonTapped
	case startGameButtonTapped
}

class AppCoordinator: Coordinator {
	
	var navigationController: UINavigationController

	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}

	func start() {
		var vc: UIViewController & Coordinating = MainViewController()
		vc.coordinator = self
		navigationController.setViewControllers([vc], animated: false)
	}

	func eventOccured(with type: Event) {
		switch type {
		case .statisticButtonTapped:
			let statisticModel = StatisticModel()
			var statisticVc: UIViewController & Coordinating = StatisticViewController(vm: statisticModel)
			statisticVc.coordinator = self
			navigationController.setViewControllers([statisticVc], animated: true)
		case .startGameButtonTapped:
			let gameModel = GameModel()
			var gameVc: UIViewController & Coordinating = GameViewController(model: gameModel)
			gameVc.coordinator = self
			navigationController.setViewControllers([gameVc], animated: true)
		}
	}
}
