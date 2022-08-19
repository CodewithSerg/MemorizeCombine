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
	private let storage = StorageService.shared

	private var info = [Info]() {
		didSet {
			infoPublisher.send(info)
		}
	}

	init() {
		let data = storage.realm?.objects(InfoObject.self).map{$0.toModel()}.suffix(5) // last 5 objects
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
		self.info = Array(data!)
		}
	}

	func getResults() -> AnyPublisher<[Info], Never> {
		return infoPublisher.eraseToAnyPublisher()
	}
}
