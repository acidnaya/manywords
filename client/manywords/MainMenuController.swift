//
//  MainMenuController.swift
//  manywords
//
//  Created by Maria Rubtsova on 04.03.2023.
//

import Foundation
import UIKit

final class MainMenuController: UIViewController, NamedDelegate {
	func setName(name: String) {
		userName = name
	}
	
	private var fastGameButton = Button()
	private var createGameButton = Button()
	private var joinGameButton = Button()
	private var rulesButton = Button()
	private var statisticsButton = Button()
	private var settingsButton = Button()
//	private var horisontalButtonStack = UIStackView()
//	private var verticalButtonStack = UIStackView()
	private var userName = UIDevice.current.identifierForVendor?.uuidString.components(separatedBy: "-")[0]
	private var gamesPlayed = 0
	private var wins = 0
	
	private var name = UILabel()
	
	private var imageView = UIImageView()
	
	private func draw() {
		let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300))

		let img = renderer.image { ctx in
			// awesome drawing code
			let rectangle = CGRect(x: 0, y: 0, width: 300, height: 300)
			
			ctx.cgContext.setLineWidth(5)
			ctx.cgContext.setStrokeColor(Theme.Colors.AccentColor.cgColor)
			ctx.cgContext.strokeEllipse(in: CGRect(x: 40, y: 40, width: 220, height: 220))

			ctx.cgContext.addRect(rectangle)
			//ctx.cgContext.drawPath(using: .fillStroke)
		}

		imageView.image = img
		self.view.addSubview(imageView)
		imageView.pinTop(to: self.view, 100)
		imageView.pinCenterX(to: self.view)
		name.text = "многослов"
		name.font = .systemFont(ofSize: Theme.Constants.FontSize, weight: .medium)
		imageView.addSubview(name)
		name.pinCenterY(to: imageView)
		name.pinCenterX(to: imageView)
	}
	
	
	private func setupView() {
		view.backgroundColor = Theme.Colors.BackgroundColor
		setupButtonStack()
		draw()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
	}
	
	private func setupButtonStack() {
		setupStatisticsButton()
		setupRulesButton()
		setupSettingsButton()
		
		let horisontalButtonStack = UIStackView(arrangedSubviews: [statisticsButton, rulesButton, settingsButton])

		horisontalButtonStack.axis = NSLayoutConstraint.Axis.horizontal
		
		horisontalButtonStack.distribution = UIStackView.Distribution.fillProportionally
	
		//horisontalButtonStack.spacing = Theme.Constants.ButtonSpacing
		//horisontalButtonStack.translatesAutoresizingMaskIntoConstraints = false
	
		setupFastGameButton()
		setupCreateGameButton()
		setupJoinGameButton()
		
		let verticalButtonStack = UIStackView(arrangedSubviews: [fastGameButton, createGameButton, joinGameButton, horisontalButtonStack])
		verticalButtonStack.axis = NSLayoutConstraint.Axis.vertical

		verticalButtonStack.distribution = UIStackView.Distribution.fillProportionally
		verticalButtonStack.spacing = Theme.Constants.ButtonSpacing
		
		self.view.addSubview(verticalButtonStack)
		verticalButtonStack.pinCenterY(to: self.view, 200)
		verticalButtonStack.pin(to: self.view, [.left: 24, .right: 24])
	}
	
	private func setupFastGameButton() {
		fastGameButton.setTitle("быстрая игра", for: .normal)
		fastGameButton.setTitleColor(Theme.Colors.AccentColor, for: .normal)
		fastGameButton.addTarget(self, action: #selector(fastGameButtonPressed), for: .touchUpInside)
	}
	
	private func setupCreateGameButton() {
		createGameButton.setTitle("создать игру", for: .normal)
		createGameButton.addTarget(self, action: #selector(createGameButtonPressed), for: .touchUpInside)
	}
	
	private func setupJoinGameButton() {
		joinGameButton.setTitle("присоединиться к игре", for: .normal)
		joinGameButton.addTarget(self, action: #selector(joinGameButtonPressed), for: .touchUpInside)
	}
	
	private func setupRulesButton() {
		rulesButton.setTitle("правила", for: .normal)
		rulesButton.addTarget(self, action: #selector(rulesButtonPressed), for: .touchUpInside)
	}
	
	private func setupStatisticsButton() {
		//statisticsButton.setWidth(Theme.Constants.ButtonHeight)
		statisticsButton.setTitle("🏆", for: .normal)
		statisticsButton.addTarget(self, action: #selector(statisticsButtonPressed), for: .touchUpInside)
	}
	
	private func setupSettingsButton() {
		//settingsButton.setWidth(Theme.Constants.ButtonHeight)
		settingsButton.setTitle("⚙️", for: .normal)
		settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
	}
	
	@objc private func fastGameButtonPressed() {
		let game : GameController = GameController()
		game.initn(id: userName ?? "default value")
		gamesPlayed += 1
		//wins += 1
		navigationController?.pushViewController(game, animated: true)
	}
	
	@objc private func createGameButtonPressed() {
		
	}
	
	@objc private func joinGameButtonPressed() {
		
	}
	
	@objc private func rulesButtonPressed() {
		let rules = RulesView()
		navigationController?.pushViewController(rules, animated: true)
	}
	
	@objc private func statisticsButtonPressed() {
		let rate = RateViewController()
		rate.initn(played: gamesPlayed, wins: wins)
		navigationController?.pushViewController(rate, animated: true)
	}
	
	@objc private func settingsButtonPressed() {
		let settings = SettingsViewController()
		settings.initn(nd: self, username: userName ?? "default value")
		navigationController?.pushViewController(settings, animated: true)
	}
}



