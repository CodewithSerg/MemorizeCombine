//
//  Coordinator.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 16.07.22.
//

import UIKit

protocol Coordinator {
	var navigationController: UINavigationController { get set }
	func eventOccured(with type: Event)
	func start()
}
