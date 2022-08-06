//
//  StatistcViewModel.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 17.07.22.
//

import Foundation
import UIKit
import Combine

final class StatisticViewModel {
	var infoData = [Info]()
	let inputVC = PassthroughSubject<[Info], Never>()
	private var cancellables = Set<AnyCancellable>()

	init() {
//		fetchInfo()
	}

	func fetchInfo() {
		FakeStorageManager.shared.getResults()
//			.receive(on: DispatchQueue.main)
//			.map{ $0 }
			.sink { completion in
				switch completion {
				case .finished:
					print("Done")
				case .failure(let error):
					print(error)
				}
			} receiveValue: {[weak self] infoData in
				guard let self = self else {return}
				self.infoData = infoData
				self.inputVC.send(infoData)
			}
			.store(in: &cancellables)

	}
}
