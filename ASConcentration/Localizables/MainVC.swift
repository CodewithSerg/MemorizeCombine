//
//  MainVC.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 14.08.22.
//

import Foundation

enum MainVC: String {
	case newGameTitle
	case statisticTitle

	var localized: String {
		NSLocalizedString(String(describing: Self.self) + "_\(rawValue)", comment: "")
	}
}
