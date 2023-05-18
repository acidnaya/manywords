//
//  RulesView.swift
//  manywords
//
//  Created by Maria Rubtsova on 17.05.2023.
//

import Foundation
import UIKit

final class RulesView : UIViewController{
	
	var rules = UITextView()
	
	private func setupView() {
		view.backgroundColor = Theme.Colors.BackgroundColor
		rules.font = .systemFont(ofSize: Theme.Constants.FontSize, weight: .medium)
		rules.backgroundColor = Theme.Colors.BackgroundColor
		rules.text = "В игре участвует от 2 до 5 игроков. Каждый игрок по очереди видит некоторое буквосочетание. Игроку необходимо за 5 секунд вписать в текстовое поле существующее существительное в именительном падеже и единственном числе, содержащее это буквосочетание, и отправить его нажав на Enter. Если игрок не успевает это сделать, то игра для него заканчивается. Последний оставшийся становится победителем игры."
		rules.isEditable = false
		rules.isSelectable = false
		rules.isScrollEnabled = true
		rules.textColor = Theme.Colors.TextColor
		self.view.addSubview(rules)
		rules.pinWidth(to: self.view)
		rules.pinHeight(to: self.view)
		rules.pinTop(to: self.view, 25)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		let newBackButton = UIBarButtonItem(title: "Назад", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.backAction(sender:)))
		newBackButton.tintColor = Theme.Colors.AccentColor
		self.navigationItem.leftBarButtonItem = newBackButton
	}
	
	@objc func backAction(sender: UIBarButtonItem) {
		self.navigationController?.popViewController(animated: true)
	}
}
