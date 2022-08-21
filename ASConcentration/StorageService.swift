//
//  StorageService.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 17.07.22.
//

import RealmSwift

protocol Storable {
	var realm: Realm? { get }
	func save<Element: Object>(_ object: Element)
	func readObjects<Element: Object>(_ type: Element.Type) -> Results<Element>?
}

final class StorageService: Storable {

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
