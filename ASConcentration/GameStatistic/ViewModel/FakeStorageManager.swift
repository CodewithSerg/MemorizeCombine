//
//  FakeStorageManager.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 2.08.22.
//

import Foundation
import Combine

final class FakeStorageManager {
	static let shared = FakeStorageManager()
	var info = [Info]()
	private let infoPublisher = PassthroughSubject<[Info], Error>()
	private var cancellables = Set<AnyCancellable>()

	func getResults() -> AnyPublisher<[Info], Error> {
		let fakeInfo = [
			Info(date: Date(), duration: 30),
			Info(date: Date(timeIntervalSinceNow: 60), duration: 50)
		]
		info = fakeInfo
//		infoPublisher.send(info)
		// TO DO
		return infoPublisher.eraseToAnyPublisher()
	}
}
