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
	let container: Container = {
		let container = Container()
		container.register(Storable.self) { _ in StorageService() }
		container.register(GameModelProtocol.self) { r in
			let gameModel = GameModel()
			gameModel.storage = r.resolve(Storable.self)
			return gameModel
		}
		container.register(UIViewController.self, name: "gameVC") { r in
			let model = r.resolve(GameModelProtocol.self)
			let gameVC = GameViewController(model: model!)
			return gameVC
		}
		container.register(FakeStorageManagerProtocol.self) { r in
			FakeStorageManager(storage: r.resolve(Storable.self)!)
		}
		container.register(StatisticModelProtocol.self) { r in
			let storage = r.resolve(FakeStorageManagerProtocol.self)
			return StatisticModel(storageManager: storage!)
		}
		container.register(UIViewController.self, name: "statisticVC") { r in
			let vm = r.resolve(StatisticModelProtocol.self)
			let statisticVC = StatisticViewController(vm: vm!)
			return statisticVC
		}
		return container
	}()

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
		case .startGameButtonTapped:
			guard let gameVc = container.resolve(UIViewController.self, name: "gameVC") else { return }
			navigationController.present(gameVc, animated: true)
		case .statisticButtonTapped:
//			let storageManger = FakeStorageManager(storage: storage)
//			let statisticModel = StatisticModel(storageManager: storageManger) // init DI
//			let statisticVc: UIViewController = StatisticViewController(vm: statisticModel)
			guard let statisticVc = container.resolve(UIViewController.self, name: "statisticVC") else { return }
			navigationController.present(statisticVc, animated: true)
//			navigationController.setViewControllers([statisticVc], animated: true)
		}
	}
}
