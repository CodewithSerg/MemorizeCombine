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
	func transform(outputVC: AnyPublisher<StatisticModel.Output, Never>) -> AnyPublisher<StatisticModel.Input, Never>
}

final class StatisticModel: StatisticModelProtocol {

	enum Output {
		case needNumberOfRowsInSection
		case viewLoaded
	}

	enum Input {
		case makeInfos(info: [Info])
		case numberOfRowsInSection(count: Int)
	}

	func transform(outputVC: AnyPublisher<Output, Never>) -> AnyPublisher<Input, Never> {
		outputVC.sink { [weak self] event in
			guard let self = self else { return }
			switch event {
			case .viewLoaded:
				self.inputVC.send(.makeInfos(info: self.infoData))
			case .needNumberOfRowsInSection:
				self.inputVC.send(.numberOfRowsInSection(count: self.infoData.count))
			}
		}.store(in: &bag)
		return inputVC.eraseToAnyPublisher()
	}
	
	private var infoData = [Info]()
//	private var infoData = [
//		Info(date: Date(), duration: 30),
//		Info(date: Date(timeIntervalSinceNow: 60), duration: 50)
//	]
	private let inputVC = PassthroughSubject<StatisticModel.Input, Never>()
	private var bag = Set<AnyCancellable>()

	init() {
//		fetchInfo()
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			self.infoData = [
				Info(date: Date(), duration: 30),
				Info(date: Date(timeIntervalSinceNow: 60), duration: 50)
			]
		}
	}

	private func fetchInfo() {
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

//				self.inputVC.send(.makeInfos(info: infoData))
			}
			.store(in: &bag)
	}
}
