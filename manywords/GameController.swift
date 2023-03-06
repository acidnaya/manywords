//
//  GameController.swift
//  manywords
//
//  Created by Maria Rubtsova on 06.03.2023.
//

import Foundation
import UIKit



final class GameController: UIViewController {
	let gameRoom = GameRoom()
//	let textView = TextView()
	let sendButton = UIButton()
	
	let textView = TextFieldViewController()

	private var syllableLabel = UILabel()
	
	private var imageView = UIImageView()
	
	private func setupSyllableLabel() {
		syllableLabel.text = "syllable"
		syllableLabel.font = .systemFont(ofSize: Theme.Constants.FontSize, weight: .medium)
		self.view.addSubview(syllableLabel)
		syllableLabel.pinTop(to: self.view, 100)
		syllableLabel.pinCenterX(to: self.view)
	}
	
	private func setupTextView() {
		self.view.addSubview(textView.textView)
		textView.textView.delegate = textView
		textView.textView.pinCenterY(to: self.view)
		textView.textView.pinCenterX(to: self.view)
	}
	
	private func setupView() {
		view.backgroundColor = Theme.Colors.BackgroundColor
		setupSyllableLabel()
		setupTextView()
	}
	
	private func setupSendButton() {
		sendButton.setTitle("->", for: .normal)
		sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
	}
	
	private func sendMessage() {
		
	}
	
	@objc private func sendButtonPressed() {
		print("I SEND SOMETHING!!!")
//		gameRoom.send(message: <#T##String#>)
	}
	
}
