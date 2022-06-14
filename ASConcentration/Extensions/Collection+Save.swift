//
//  Collection+Save.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 14.06.22.
//

extension Collection {
	subscript (safe index: Index) -> Element? {
		indices.contains(index) ? self[index] : nil
	}
}
