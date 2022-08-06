//
//  StatisticViewController.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 17.07.22.
//

import UIKit
import Combine

class StatisticViewController: UIViewController, Coordinating, UITableViewDelegate, UITableViewDataSource {
	var countInSection = 0
	var infoData = [Info]()

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		countInSection
	}


	var coordinator: Coordinator?

	let vm: StatisticModelProtocol
	private let outputVC = PassthroughSubject<StatisticModel.Output, Never>()
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
//		fetchInfos()
		bind()
    }

	private func bind() {
		let input = vm.transform(outputVC: outputVC.eraseToAnyPublisher())
		input
			.receive(on: DispatchQueue.main)
			.sink { [weak self] event in
				switch event {
				case .numberOfRowsInSection(count: let count):
					self?.countInSection = count
				case .makeInfos(info: let info):
					self?.infoData = info
					self?.tableView.reloadData()
				}
			}
			.store(in: &bag)
	}

//	private func fetchInfos() {
//
//		vm.inputVC
//			.receive(on: DispatchQueue.main)
//			.sink {[weak self] _ in
//				self?.tableView.reloadData()
//			}
//			.store(in: &bag)
//		vm.fetchInfo()
//	}

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

//	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////		vm.infoData.count
//		outputVC.send(.needNumberOfRowsInSection)
//	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.reuseIdentifier, for: indexPath) as? CustomCell else { return UITableViewCell() }
//		vm.inputVC
//				.receive(on: DispatchQueue.main)
//				.sink { allInfo in
//					cell.configureCell(with: allInfo[indexPath.row])
//				}
//				.store(in: &bag)
			return cell
	}
}

