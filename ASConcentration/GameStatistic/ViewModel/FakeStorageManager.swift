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
	private let infoPublisher = PassthroughSubject<[Info], Never>()

	private var info = [Info]() {
		didSet {
			infoPublisher.send(info)
		}
	}

	init() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.info = [
				Info(date: Date(), duration: 30),
				Info(date: Date(timeIntervalSinceNow: 60), duration: 50)
			]
		}
	}

	func getResults() -> AnyPublisher<[Info], Never> {
		return infoPublisher.eraseToAnyPublisher()
	}
}
