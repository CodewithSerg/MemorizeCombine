//
//  StatisticViewController.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 17.07.22.
//

import UIKit
import Combine

class StatisticViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	let vm: StatisticModelProtocol
	private var bag = Set<AnyCancellable>()

	let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.reuseIdentifier)
		return tableView
	}()

	init(vm: StatisticModelProtocol) {
		self.vm = vm
		super.init(nibName: nil, bundle: nil)
	}

	@available (*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
		tableView.delegate = self
		tableView.dataSource = self
		bind()
    }

	private func bind() {
		vm.inputVC
			.receive(on: RunLoop.main)
			.sink { [weak self] event in
				switch event {
				case .needUpdateTableView:
					self?.tableView.reloadData()
				}
			}
			.store(in: &bag)
	}

	private func setupView() {
		view.addSubview(tableView)
		tableView.snp.makeConstraints {
			$0.centerX.equalToSuperview()
			$0.centerY.equalToSuperview()
			$0.width.equalToSuperview()
			$0.height.equalToSuperview()
		}
	}

	// MARK: - UITableViewDelegate, UITableViewDataSource

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		vm.infoData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(
			withIdentifier: CustomCell.reuseIdentifier,
			for: indexPath
		) as? CustomCell else { return UITableViewCell() }
		let info = vm.infoData[indexPath.row]
		cell.configureCell(with: info)
		return cell
	}
}

