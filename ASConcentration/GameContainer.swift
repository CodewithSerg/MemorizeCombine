//
//  GameContainer.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 14.08.22.
//

import Foundation
import Swinject

final class GameContainer {
	func setupContainer(using container: Container) {
		container.register(UITableViewCell.self) { _ in
			CustomCell()
		}
	}
}
