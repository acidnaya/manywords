//
//  Theme.swift
//  manywords
//
//  Created by Maria Rubtsova on 04.03.2023.
//

import Foundation
import UIKit

final class Theme {

	final class Constants {
		class var ButtonHeight: Int {
			return 48;
		}
		
		class var CornerRadius: CGFloat {
			return 12;
		}
		
		class var FontSize: CGFloat {
			return 24;
		}
		
		class var ButtonSpacing: CGFloat {
			return 5;
		}

	}

	final class Colors {
		class var BackgroundColor: UIColor {
			return UIColor(named: "BackgroundColor") ?? UIColor.white;
		}
		
		class var AccentColor: UIColor {
			return UIColor(named: "AccentTextColor") ?? UIColor.white;
		}
		
		class var TextColor: UIColor {
			return UIColor(named: "MainTextColor") ?? UIColor.white;
		}
		
		class var ButtonColor: UIColor {
			return UIColor(named: "ButtonColor") ?? UIColor.white;
		}
	}

}
