//
//  SceneDelegate.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 14.05.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
	var coordinator: AppCoordinator?

    func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
		let navigationController = UINavigationController()
		coordinator = AppCoordinator(navigationController: navigationController)
		window = UIWindow(windowScene: windowScene)
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
		coordinator?.start()
    }
}
