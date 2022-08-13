//
//  StatistcModel.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 17.07.22.
//

import Foundation
import UIKit
import Combine

protocol StatisticModelProtocol {
	var inputVC: PassthroughSubject<StatisticModel.Input, Never> { get }
	var infoData: [Info] { get }
}

final class StatisticModel: StatisticModelProtocol {

	enum Input {
		case needUpdateTableView
	}

	private (set) var infoData = [Info]() {
		didSet {
			inputVC.send(.needUpdateTableView)
		}
	}

	let inputVC = PassthroughSubject<StatisticModel.Input, Never>()
	private var bag = Set<AnyCancellable>()

	init() {
		bindForInfo()
	}

	private func bindForInfo() {
		let storage = FakeStorageManager.shared.getResults()
		storage
			.sink { [weak self] infoData in
				guard let self = self else {return}
				self.infoData = infoData
			}
			.store(in: &bag)
	}
}
