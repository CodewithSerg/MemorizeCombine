//
//  StatisticViewController.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 17.07.22.
//

import UIKit
import Combine

class StatisticViewController: UIViewController, Coordinating {

	var coordinator: Coordinator?

	let vm = StatisticViewModel()
	private var cancellables = Set<AnyCancellable>()

	let tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.reuseIdentifier)
		return tableView
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		setupView()
		tableView.delegate = self
		tableView.dataSource = self
		fetchInfos()
    }

	private func fetchInfos() {

		vm.inputVC
			.receive(on: DispatchQueue.main)
			.sink {[weak self] _ in
				self?.tableView.reloadData()
			}
			.store(in: &cancellables)
		vm.fetchInfo()
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
}

extension StatisticViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		vm.infoData.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.reuseIdentifier, for: indexPath) as? CustomCell else { return UITableViewCell() }
		vm.inputVC
				.receive(on: DispatchQueue.main)
				.sink { allInfo in
					cell.configureCell(with: allInfo[indexPath.row])
				}
				.store(in: &cancellables)
			return cell
	}
}

