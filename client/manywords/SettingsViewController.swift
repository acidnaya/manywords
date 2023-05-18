//
//  SettingsViewController.swift
//  manywords
//
//  Created by Maria Rubtsova on 13.05.2023.
//

import Foundation
import UIKit

final class SettingsViewController : UIViewController, GameRoomDelegate {
	var userName = Label()
	var textView = UITextView()
	var button = Button()
	var messageLabel = Label()
	let gameRoom = GameRoom()
	
	func setupButton() {
		button.setTitle("Изменить имя", for: .normal)
		button.setTitleColor(Theme.Colors.AccentColor, for: .normal)
		button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
	}
	
	@objc func buttonPressed() {
		gameRoom.send(message: Message(e: "change_name", p: userName.text ?? " ", g: "", o: "", s: "", a: textView.text, ms: "", t: "", f: ""))
	}
	
	func setupLabel() {
		messageLabel.text = "             "
		userName.text = UserDefaults.standard.string(forKey: DefaultsKeys.username)
		print("имя = " + UserDefaults.standard.string(forKey: DefaultsKeys.username)!)
	}
	
	private func setupStack() {
		setupButton()
		setupTextView()
		setupLabel()
		
		let verticalStack = UIStackView(arrangedSubviews: [userName, textView, button, messageLabel])
		verticalStack.axis = NSLayoutConstraint.Axis.vertical
		verticalStack.distribution = UIStackView.Distribution.fillProportionally
		verticalStack.spacing = Theme.Constants.ButtonSpacing * 2
		
		self.view.addSubview(verticalStack)
		verticalStack.pinCenterY(to: self.view, 50)
		verticalStack.pin(to: self.view, [.left: 24, .right: 24])
	}
	
	func setupTextView() {
		textView.text = ""
		textView.font = .systemFont(ofSize: Theme.Constants.FontSize, weight: .medium)
		textView.setHeight(Theme.Constants.ButtonHeight)
		textView.layer.cornerRadius = Theme.Constants.CornerRadius
		textView.backgroundColor = Theme.Colors.ButtonColor
		textView.textColor = Theme.Colors.AccentColor
		textView.autocorrectionType = UITextAutocorrectionType.no
		textView.autocapitalizationType = UITextAutocapitalizationType.none
	}
	
	private func setupView() {
		view.backgroundColor = Theme.Colors.BackgroundColor
		setupStack()
	}
	
	func received(message: Message) {
		switch message.EventType {
		case "ok":
			updateName()
		case "error":
			declineName()
		default:
			print("Не удалось распознать команду")
		}
	}
	
	func updateName() {
		userName.text = textView.text
		textView.text = ""
		UserDefaults.standard.set(userName.text, forKey: DefaultsKeys.username)
		messageLabel.text = "Имя изменено"
	}
	
	func declineName() {
		textView.text = ""
		messageLabel.text = "Имя уже занято"
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		gameRoom.initn(gc: self)
		gameRoom.setupNetworkCommunication()
		setupView()
		let newBackButton = UIBarButtonItem(title: "Назад", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.backAction(sender:)))
		newBackButton.tintColor = Theme.Colors.AccentColor
		self.navigationItem.leftBarButtonItem = newBackButton
	}
	
	@objc func backAction(sender: UIBarButtonItem) {
		self.navigationController?.popViewController(animated: true)
	}
}
