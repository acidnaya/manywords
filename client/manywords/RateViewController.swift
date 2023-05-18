//
//  RulesViewController.swift
//  manywords
//
//  Created by Maria Rubtsova on 13.05.2023.
//

import Foundation
import UIKit

final class RateViewController : UIViewController {
	let winsNameLabel = Label()
	var winsLabel = Label()
	let playedNameLabel = Label()
	var playedLabel = Label()
	
	private func setupHorisontalStack(views: [UIView]) -> UIStackView {
		let stack = UIStackView(arrangedSubviews: views)
		stack.axis = NSLayoutConstraint.Axis.horizontal
		stack.distribution = UIStackView.Distribution.fillProportionally
		return stack
	}
	
	private func setupStack() {
		let h1 = setupHorisontalStack(views: [playedNameLabel, winsNameLabel])
		let h2 = setupHorisontalStack(views: [playedLabel, winsLabel])
		let stack = UIStackView(arrangedSubviews: [h1, h2])
		stack.axis = NSLayoutConstraint.Axis.vertical
		stack.distribution = UIStackView.Distribution.fillProportionally
		
		self.view.addSubview(stack)
		stack.pinCenterY(to: self.view, 50)
		stack.pin(to: self.view, [.left: 24, .right: 24])
	}
	
	private func setupView() {
		view.backgroundColor = Theme.Colors.BackgroundColor
		playedNameLabel.text = "Сыграно"
		winsNameLabel.text = "Побед"
		winsLabel.text = UserDefaults.standard.string(forKey: DefaultsKeys.wins)
		playedLabel.text = UserDefaults.standard.string(forKey: DefaultsKeys.played)
		setupStack()
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
