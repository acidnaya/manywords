//
//  TextFieldViewController.swift
//  manywords
//
//  Created by Maria Rubtsova on 06.03.2023.
//

import Foundation
import UIKit

class TextFieldViewController: UIViewController, UITextViewDelegate
{
	var textView = TextView()
	
	override func viewDidLoad() {
		//textView.delegate = self
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if text == "\n" {
			// выполнить нужное действие
			print("ТИПА ЭНТЕР ПОСЛЕДНИЙ")
			return false // чтобы UITextView не добавлял дополнительную строку
		}
		return true
	}
	
//	func textViewDidChange(_ textView: UITextView) {
//		print("ПРОВЕРЯЕМ ПОСЛЕДНИЙ СИМВОЛ")
//		if let character = textView.text.last, character.isNewline {// first
//			//textView.resignFirstResponder() // че дел?
//			print("ТИПА ЭНТЕР ПОСЛЕДНИЙ")
//		}
//	}
}
