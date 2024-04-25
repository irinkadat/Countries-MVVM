//
//  UIColor+DarkMode.swift
//  Countries
//
//  Created by Irinka Datoshvili on 25.04.24.
//

import Foundation
import UIKit
// MARK: - Dark Mode

extension UIColor {
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { traits in
            switch traits.userInterfaceStyle {
            case .dark:
                return dark
            default:
                return light
            }
        }
    }
}
