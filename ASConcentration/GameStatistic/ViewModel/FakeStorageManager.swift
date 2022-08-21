//
//  FakeStorageManager.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 2.08.22.
//

import Foundation
import Combine

protocol FakeStorageManagerProtocol {
	func getResults() -> AnyPublisher<[Info], Never>
}

final class FakeStorageManager: FakeStorageManagerProtocol {

	var storage: Storable
	private let infoPublisher = PassthroughSubject<[Info], Never>()

	private var info = [Info]() {
		didSet {
			infoPublisher.send(info)
		}
	}

	init(storage: Storable) {
		self.storage = storage
		let data = storage.realm?.objects(InfoObject.self).map{$0.toModel()}.suffix(5) // last 5 objects
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
		self.info = Array(data!)
		}
	}

	func getResults() -> AnyPublisher<[Info], Never> {
		return infoPublisher.eraseToAnyPublisher()
	}
}
