//
//  StorageService.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 17.07.22.
//

import RealmSwift

final class StorageService {

	static let shared = StorageService()

	var realm: Realm?

	init() {
		realm = try? Realm()
	}

	func readObjects<Element: Object>(_ type: Element.Type) -> Results<Element>? {
		realm?.objects(type)
	}

	func save<Element: Object>(_ object: Element) {
		do {
			try realm?.write {
				realm?.add(object)
			}
		} catch let error as NSError {
			print(error.localizedDescription)
		}
	}
}
