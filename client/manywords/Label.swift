//
//  Label.swift
//  manywords
//
//  Created by Maria Rubtsova on 08.05.2023.
//

import Foundation
import UIKit

final class Label: UILabel {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupLabel()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupLabel()
	}

	func setupLabel() {
		self.font = .systemFont(ofSize: Theme.Constants.FontSize, weight: .medium)
		self.textColor = Theme.Colors.TextColor
		self.textAlignment = .center
	}
}
