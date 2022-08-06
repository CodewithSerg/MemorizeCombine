//
//  CustomCell.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 17.07.22.
//

import UIKit

final class CustomCell: UITableViewCell {

	static let reuseIdentifier = "CustomCell"

	let infoLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		return label
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .value1, reuseIdentifier: reuseIdentifier)
		setupView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}

	private func setupView() {
		addSubview(infoLabel)
		infoLabel.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.centerY.equalToSuperview()
			$0.width.equalToSuperview()
			$0.height.equalToSuperview()
		}
	}

	func configureCell(with info: Info) {
		infoLabel.text = "Result: \(info.date) with \(info.duration)"
	 }
}
