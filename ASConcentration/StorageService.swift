//
//  StorageService.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 17.07.22.
//

//import RealmSwift
//
//final class StorageService {
//
//	// MARK: - Private Properties
//
//	var realm: Realm?
//
//	init() {
//		realm = try? Realm()
//	}
//
//	// MARK: - Methods
//
//	func readObjects<Element: Object>(_ type: Element.Type) -> Results<Element>? {
//		realm?.objects(type)
//	}
//
//	func create<Element: Object>(_ object: Element) {
//		do {
//			try realm?.write {
//				realm?.add(object)
//			}
//		} catch let error as NSError {
//			print(error.localizedDescription)
//		}
//	}
//
//	func delete<Element: Object>(_ object: Element?) {
//		guard let object = object else { return }
//		do {
//			try realm?.write {
//				realm?.delete(object)
//			}
//		} catch let error as NSError {
//			print(error.localizedDescription)
//		}
//	}
//
//	func update<Element: Object>(_ object: Element, with dictionary: [String: Any?]) {
//		do {
//			try realm?.write {
//				dictionary.forEach { key, value in
//					object.setValue(value, forKey: key)
//				}
//			}
//		} catch let error as NSError {
//			print(error.localizedDescription)
//		}
//	}
//}
