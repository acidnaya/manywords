//
//  TextView.swift
//  manywords
//
//  Created by Maria Rubtsova on 07.03.2023.
//

import Foundation
import UIKit

final class TextView: UITextView {
	
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		setupTextView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupTextView()
	}

	func setupTextView() {
//		translatesAutoresizingMaskIntoConstraints = false
		font = .systemFont(ofSize: Theme.Constants.FontSize, weight: .medium)
		setWidth(300)
		setHeight(Theme.Constants.ButtonHeight)
		layer.cornerRadius = Theme.Constants.CornerRadius
		backgroundColor = Theme.Colors.ButtonColor
		textColor = Theme.Colors.AccentColor
	}
}
