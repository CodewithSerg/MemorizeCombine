//
//  AppCoordinator.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 16.07.22.
//

import UIKit
import Swinject

enum Event {
	case statisticButtonTapped
	case startGameButtonTapped
}

class AppCoordinator: Coordinator {
	
	var navigationController: UINavigationController
	static let container = Container()

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
			let statisticVc: UIViewController = StatisticViewController(vm: statisticModel)
			navigationController.setViewControllers([statisticVc], animated: true)
		case .startGameButtonTapped:
			let gameModel = GameModel()
			let gameVc: UIViewController = GameViewController(model: gameModel)
			navigationController.setViewControllers([gameVc], animated: true)
		}
	}
}
