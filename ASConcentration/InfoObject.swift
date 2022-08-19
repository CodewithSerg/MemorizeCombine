//
//  InfoObject.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 17.07.22.


import RealmSwift

@objcMembers class InfoObject: Object {

	dynamic var date = Date()
	dynamic var duration = Int()

	convenience init(date: Date, duration: Int) {
		self.init()
		self.date = date
		self.duration = duration
	}

	func toModel() -> Info {
		Info(date: date, duration: duration)
	}
}
