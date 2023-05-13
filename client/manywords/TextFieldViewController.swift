//
//  TextFieldViewController.swift
//  manywords
//
//  Created by Maria Rubtsova on 06.03.2023.
//

import Foundation
import UIKit

protocol MoveSenderDelegate: AnyObject {
	func send(message: String, type: String)
}

class TextFieldViewController: UIViewController, UITextViewDelegate
{
	var textView = TextView()
	weak var senderDelegate: MoveSenderDelegate?
	
	override func viewDidLoad() {
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			if (senderDelegate != nil) {
				textView.isEditable = false
				senderDelegate?.send(message: textView.text, type: "move")
			}
			return false // чтобы UITextView не добавлял дополнительную строку
		} else {
			if (senderDelegate != nil) {
				senderDelegate?.send(message: textView.text + text, type: "attempt")
			}
		}
		return true
	}
}
