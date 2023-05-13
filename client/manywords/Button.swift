//
//  Button.swift
//  manywords
//
//  Created by Maria Rubtsova on 04.03.2023.
//

import Foundation
import UIKit

final class Button: UIButton {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupButton()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupButton()
	}

	func setupButton() {
		translatesAutoresizingMaskIntoConstraints = false
		setTitleColor(Theme.Colors.TextColor, for: .normal)
		//setHeight(Theme.Constants.ButtonHeight)
		layer.cornerRadius = Theme.Constants.CornerRadius
		titleLabel?.font = .systemFont(ofSize: Theme.Constants.FontSize, weight: .medium)
		backgroundColor = Theme.Colors.ButtonColor
		//self.focusEffect
	}
}
