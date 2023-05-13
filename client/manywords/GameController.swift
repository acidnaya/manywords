//
//  GameController.swift
//  manywords
//
//  Created by Maria Rubtsova on 06.03.2023.
//

import Foundation
import UIKit

final class GameController: UIViewController, GameRoomDelegate {
	let gameRoom = GameRoom()
	let textView = TextFieldViewController()
	var deviceId = UIDevice.current.identifierForVendor?.uuidString.components(separatedBy: "-")[0]
	private var timerLabel = Label()
	private var syllableLabel = Label()
	var playerLabels = [Label](repeating: Label(), count: 6)
	var playerLabel0 = Label()
	var playerLabel1 = Label()
	var playerLabel2 = Label()
	var playerLabel3 = Label()
	var playerLabel4 = Label()
	var messageLabel = Label()
	
	func initn(id: String) {
		deviceId = id
	}
	
	private func setupTableView() {
		playerLabels[0] = playerLabel0
		playerLabels[1] = playerLabel1
		playerLabels[2] = playerLabel2
		playerLabels[3] = playerLabel3
		playerLabels[4] = playerLabel4
		playerLabels[5] = messageLabel
		
		let verticalPlayersStack = UIStackView(arrangedSubviews: playerLabels)
		verticalPlayersStack.axis = NSLayoutConstraint.Axis.vertical
		verticalPlayersStack.distribution = UIStackView.Distribution.fillEqually
		verticalPlayersStack.spacing = Theme.Constants.ButtonSpacing
		self.view.addSubview(verticalPlayersStack)
		verticalPlayersStack.pinCenterY(to: self.view, 200)
		verticalPlayersStack.pinCenterX(to: self.view)
	}
	
	private func setupLabelsStack() {
		//setupTimerLabel()
		//setupSyllableLabel()
		syllableLabel.text = "Игра скоро начнется!"
		syllableLabel.textColor = Theme.Colors.AccentColor
		let verticalLabelsStack = UIStackView(arrangedSubviews: [timerLabel, syllableLabel])
		verticalLabelsStack.axis = NSLayoutConstraint.Axis.vertical
		verticalLabelsStack.distribution = UIStackView.Distribution.fillEqually
		verticalLabelsStack.spacing = Theme.Constants.LabelSpacing
		self.view.addSubview(verticalLabelsStack)
		verticalLabelsStack.pinTop(to: self.view, 100)
		verticalLabelsStack.pinCenterX(to: self.view)
	}
	
	private func setupTextView() {
		self.view.addSubview(textView.textView)
		textView.senderDelegate = gameRoom
		textView.textView.delegate = textView
		textView.textView.pinCenterY(to: self.view)
		textView.textView.pinCenterX(to: self.view)
		textView.textView.isHidden = true
	}
	
	private func setupView() {
		gameRoom.initn(gc: self, id: deviceId ?? "default value")
		view.backgroundColor = Theme.Colors.BackgroundColor
		//setupSyllableLabel()
		setupLabelsStack()
		setupTextView()
		setupTableView()
		gameRoom.setupNetworkCommunication()
		let msg = Message(e: "fast", p: deviceId!, g: "", o: "", s: "", a: "", ms: "", t: "", f: "false")
		gameRoom.send(message: msg)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		//
		let newBackButton = UIBarButtonItem(title: "Назад", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.backAction(sender:)))
		newBackButton.tintColor = Theme.Colors.AccentColor
		self.navigationItem.leftBarButtonItem = newBackButton
	}
	
	@objc func backAction(sender: UIBarButtonItem) {
		let alertController = UIAlertController(title: "Вы уверены, что хотите выйти?", message: "Если покинете игру, возобновить ее не получится.", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Да", style: .default) { (result : UIAlertAction) -> Void in
			self.gameRoom.stopGameSession()
			self.navigationController?.popViewController(animated: true)
		}
		
		let cancelAction = UIAlertAction(title: "Нет", style: .default, handler: nil)
		alertController.addAction(cancelAction)
		alertController.addAction(okAction)
		
		clearBackgroundColor(of: alertController.view)
		alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = Theme.Colors.BackgroundColor.withAlphaComponent(0.8)
		alertController.view.tintColor = Theme.Colors.TextColor
		
		self.present(alertController, animated: true)
	}
	
	func received(message: Message) {
		switch message.EventType {
		case "attempt":
			print("Переменная равна attempt")
			attempt(message: message)
		case "move":
			print("Переменная равна move")
			move(message: message)
		case "change_player":
			print("Переменная равна change_player")
			activate(message: message)
		case "start":
			print("Переменная равна start")
		case "winner":
			print("Переменная равна winner")
			end(message: message)
		case "tie":
			print("Переменная равна tie")
			tie()
		case "timer":
			print("Переменная равна timer")
			changeTimer(message: message)
		case "end":
			print("Переменная равна timer")
			noPlayersFound()
		default:
			print("не удалось распознать число")
		}
	}
	
	func changeTimer(message: Message) {
		timerLabel.text = message.Time
		updatePlayerLabels(message: message)
	}
	
	func clearBackgroundColor(of view: UIView) {
		if let effectsView = view as? UIVisualEffectView {
			effectsView.removeFromSuperview()
			return
		}
		
		view.backgroundColor = .clear
		view.subviews.forEach { (subview) in
			clearBackgroundColor(of: subview)
		}
	}
	
	func end(message: Message) {
		if message.PlayerID == deviceId {
			winner()
		} else {
			loser()
		}
	}
	
	func noPlayersFound() {
		let alertController = UIAlertController(title: "Не удалось найти соперников", message: "Попробуйте еще раз", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "💔", style: .default) { (result : UIAlertAction) -> Void in
			self.gameRoom.stopGameSession()
			self.navigationController?.popViewController(animated: true)
		}
		alertController.addAction(okAction)
		
		clearBackgroundColor(of: alertController.view)
		alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = Theme.Colors.BackgroundColor.withAlphaComponent(0.8)
		alertController.view.tintColor = Theme.Colors.TextColor
		
		self.present(alertController, animated: true)
	}
	
	func tie() {
		let alertController = UIAlertController(title: "Ничья", message: "Ваши силы оказались равны...", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "⚖️", style: .default) { (result : UIAlertAction) -> Void in
			self.gameRoom.stopGameSession()
			self.navigationController?.popViewController(animated: true)
		}
		alertController.addAction(okAction)
		
		clearBackgroundColor(of: alertController.view)
		alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = Theme.Colors.BackgroundColor.withAlphaComponent(0.8)
		alertController.view.tintColor = Theme.Colors.TextColor
		
		self.present(alertController, animated: true)
	}
	
	func loser() {
		let alertController = UIAlertController(title: "Поражение", message: "В следующий раз получится лучше...", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "💔", style: .default) { (result : UIAlertAction) -> Void in
			self.gameRoom.stopGameSession()
			self.navigationController?.popViewController(animated: true)
		}
		alertController.addAction(okAction)
		
		clearBackgroundColor(of: alertController.view)
		alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = Theme.Colors.BackgroundColor.withAlphaComponent(0.8)
		alertController.view.tintColor = Theme.Colors.TextColor
		
		self.present(alertController, animated: true)
	}
	
	func winner() {
		let alertController = UIAlertController(title: "Победа!", message: "Поздравляю, вы победили!🎉🎉🎉", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "❤️", style: .default) { (result : UIAlertAction) -> Void in
			self.gameRoom.stopGameSession()
			self.navigationController?.popViewController(animated: true)
		}
		alertController.addAction(okAction)
		
		clearBackgroundColor(of: alertController.view)
		alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = Theme.Colors.BackgroundColor.withAlphaComponent(0.8)
		alertController.view.tintColor = Theme.Colors.TextColor
		
		self.present(alertController, animated: true)
	}
	
	func updatePlayerLabels(message: Message){
		let players = message.OtherPlayers.components(separatedBy: ",")
		for i in 0..<playerLabels.count {
			if players.count <= i {
				playerLabels[i].text = ""
				continue
			}
			playerLabels[i].text = players[i]
			if (players[i] == message.PlayerID) {
				playerLabels[i].textColor = Theme.Colors.AccentColor
			} else {
				playerLabels[i].textColor = Theme.Colors.TextColor
			}
		}
	}
	
	func activate(message: Message) {
		timerLabel.text = ""
		syllableLabel.text = message.Syllable
		textView.textView.isHidden = false
		textView.textView.text = ""
		textView.textView.textColor = Theme.Colors.TextColor
		updatePlayerLabels(message: message)
		
		if deviceId == message.PlayerID {
			gameRoom.moveCounter += 1
			textView.textView.isEditable = true
			Task {
				await waitAndMove(k: gameRoom.moveCounter)
			}
		} else {
			textView.textView.isEditable = false
		}
	}
	
	
	func waitAndMove(k: Int) async {
		print(deviceId! + " move #" + String(k) + ": Запустили таймер на 5 сек")
		let duration = UInt64(5 * 1_000_000_000)
		do {
			try await Task.sleep(nanoseconds: duration)
			if !gameRoom.moveWasMade[k] {
				print(deviceId! + " move #" + String(k) + ": Отправляем пустой ход")
				gameRoom.send(message: textView.textView.text, type: "move")
			} else {
				print(deviceId! + " move #" + String(k) + ": Уже отправили нормальный ход.")
			}
		} catch {
			print("Ошибка в ожидании, лол")
		}
	}
	
	func attempt(message: Message) {
		if deviceId != message.PlayerID {
			textView.textView.text = message.MoveAttempt
		} else {
		}
	}
	
	func move(message: Message) {
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: Theme.Colors.TextColor,
			.font: UIFont.systemFont(ofSize: Theme.Constants.FontSize)
		]

		let attributedString = NSMutableAttributedString(string: message.MoveAttempt, attributes: attributes)
		if message.MoveStatus == "correct" {
			let rangeRight = (textView.textView.text as NSString).range(of: message.Syllable)
			attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: Theme.Colors.AccentColor, range: rangeRight)
		}
		
		textView.textView.attributedText = attributedString
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		if self.isMovingFromParent {
			gameRoom.send(message: "exit", type: "exit")
		}
	}
}
