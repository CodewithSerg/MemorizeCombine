//
//  GameString.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 14.08.22.
//

import Foundation

enum GameVC: String {
	case newGameTitle

	var localized: String {
		NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
	}
}
