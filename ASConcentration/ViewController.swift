//
//  ViewController.swift
//  ASConcentration
//
//  Created by Sergey Antoniuk on 14.05.22.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let game = ViewModel()

    let labelCount: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.text = "Count of taps 200"
        return label
    }()

    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEW GAME", for: .normal)
        return button
    }()

    var cardsButtons = [UIButton]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let columns = UIScreen.main.bounds.width > UIScreen.main.bounds.width ? 6 : 4
        let rows = Int(ceil(Float(game.emojies.count)/Float(columns)))
        stackedGrid(rows: rows, columns: columns, rootView: self.view)
        self.view.backgroundColor = .blue
    }

    func stackedGrid(rows: Int, columns: Int, rootView: UIView){

        // Init StackView
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5


        stackView.addArrangedSubview(labelCount)

        var emojies = game.emojies
        for row in 0 ..< rows {
            let horizontalSv = UIStackView()
            horizontalSv.axis = .horizontal
            horizontalSv.alignment = .fill
            horizontalSv.distribution = .fillEqually
            horizontalSv.spacing = 5

            for col in 0 ..< columns {
                let button = UIButton(type: .system)
                button.backgroundColor = .orange
                button.titleLabel?.font = .systemFont(ofSize: 40)
                button.layer.cornerRadius = 6
                button.layer.opacity = emojies.isEmpty ? 0 : 1
                button.setTitle(emojies.isEmpty ? "" : emojies.removeFirst(), for: .normal)
//                button.addTarget(self, action: #selector(onButton), for: .touchUpInside)
                horizontalSv.addArrangedSubview(button)
            }
            stackView.addArrangedSubview(horizontalSv)
        }
        stackView.addArrangedSubview(button)
        rootView.addSubview(stackView)


        // add constraints
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
    }

    func updateViewModel() {
        for index in cardsButtons.indices {
            let button = cardsButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = card.isMatched ? .clear : .orange
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? .clear : .orange
            }
        }
    }

    var emojiChoices = ["🐸", "🦊", "🦋", "🐶", "🐸", "🦊", "🦋", "🐶"]

    func emoji(for card: Card) -> String {
        emojiChoices.remove(at: Int.random(in: 0 ..< emojiChoices.count))
    }
}



