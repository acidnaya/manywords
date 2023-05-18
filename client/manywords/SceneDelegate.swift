//
//  SceneDelegate.swift
//  manywords
//
//  Created by Maria Rubtsova on 04.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		let launchedBefore = UserDefaults.standard.bool(forKey: DefaultsKeys.launchedBefore)
		if !launchedBefore {
			print("Первый запуск приложения")
			let device = UIDevice.current.identifierForVendor?.uuidString.components(separatedBy: "-")[0]
			UserDefaults.standard.set(0, forKey: DefaultsKeys.played)
			UserDefaults.standard.set(0, forKey: DefaultsKeys.wins)
			UserDefaults.standard.set(device, forKey: DefaultsKeys.username)
			UserDefaults.standard.set(true, forKey: DefaultsKeys.launchedBefore)
		} else {
			print("Не первый запуск приложения")
		}
		guard let windowScene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: windowScene)
		let navigationController = UINavigationController(rootViewController: MainMenuController())
		window.rootViewController = navigationController
		self.window = window
		window.makeKeyAndVisible()
	}
	
	func sceneDidDisconnect(_ scene: UIScene) {
	}
	
	func sceneDidBecomeActive(_ scene: UIScene) {
	}
	
	func sceneWillResignActive(_ scene: UIScene) {
	}
	
	func sceneWillEnterForeground(_ scene: UIScene) {
	}
	
	func sceneDidEnterBackground(_ scene: UIScene) {
	}
}

