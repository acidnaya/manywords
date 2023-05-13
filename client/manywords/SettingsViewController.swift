//
//  SettingsViewController.swift
//  manywords
//
//  Created by Maria Rubtsova on 13.05.2023.
//

import Foundation
import UIKit

protocol NamedDelegate: AnyObject {
	func setName(name: String)
}

final class SettingsViewController : UIViewController, GameRoomDelegate {
	var userName = Label()
	var textView = UITextView()
	var button = Button()
	var messageLabel = Label()
	let gameRoom = GameRoom()
	weak var delegate: NamedDelegate?
	
	func initn(nd: NamedDelegate, username: String) {
		delegate = nd
		userName.text = username
	}
	
	func setupButton() {
		button.setTitle("Изменить имя", for: .normal)
		button.setTitleColor(Theme.Colors.AccentColor, for: .normal)
		button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
	}
	
	@objc func buttonPressed() {
		if textView.text != "игрок1" {
			updateName()
			print("update")
		} else {
			declineName()
			print("decline")
//			updateName()
		}
	}
	
	func setupLabel() {
		messageLabel.text = "             "
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
		//setWidth(300)
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
		//gameRoom.initn(gc: self)
	}
	
	func received(message: Message) {
		switch message.EventType {
		case "name":
			if message.MoveStatus == "correct" {
				print("Имя было изменено")
			} else {
				print("Имя НЕ было изменено")
			}
		default:
			print("не удалось распознать команду")
		}
	}
	
	func updateName() {
		delegate?.setName(name: textView.text)
		userName.text = textView.text
		textView.text = ""
		messageLabel.text = "Имя изменено"
	}
	
	func declineName() {
		textView.text = ""
		messageLabel.text = "Имя уже занято"
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		let newBackButton = UIBarButtonItem(title: "Назад", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.backAction(sender:)))
		newBackButton.tintColor = Theme.Colors.AccentColor
		self.navigationItem.leftBarButtonItem = newBackButton
		//self.title = "C"
	}
	
	@objc func backAction(sender: UIBarButtonItem) {
		self.navigationController?.popViewController(animated: true)
	}
}
