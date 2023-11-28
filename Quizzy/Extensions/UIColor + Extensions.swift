//
//  UIColor + Extensions.swift
//  Quizzy
//
//  Created by #include tech. on 24/11/23.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    static var primary: UIColor {
        return UIColor(hex: "FFFFFF")
    }
    
    static var secondary: UIColor {
        return UIColor(hex: "222222")
    }
    
    static var tertiary: UIColor {
        return UIColor(hex: "E1F396")
    }
    
    static var accent: UIColor {
        return UIColor(hex: "015055")
    }
}
