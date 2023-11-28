//
//  UIFont + Extensions.swift
//  Quizzy
//
//  Created by #include tech. on 24/11/23.
//

import Foundation
import UIKit

enum QFontWeight {
    case regular, bold, semibold, medium, light
}

extension UIFont {
    static func qFont(weight: QFontWeight, size: CGFloat) -> UIFont {
        switch weight {
        case .regular:
            if let font = UIFont(name: Constants.kW_FONT_SPACEGROTESK_REGULAR, size: size) {
                return font
            }
            return UIFont.systemFont(ofSize: size, weight: .regular)
            
        case .bold:
            if let font = UIFont(name: Constants.kW_FONT_SPACEGROTESK_BOLD, size: size) {
                return font
            }
            return UIFont.systemFont(ofSize: size, weight: .bold)
            
        case .semibold:
            if let font = UIFont(name: Constants.kW_FONT_SPACEGROTESK_SEMIBOLD, size: size) {
                return font
            }
            return UIFont.systemFont(ofSize: size, weight: .semibold)
        case .medium:
            if let font = UIFont(name: Constants.kW_FONT_SPACEGROTESK_MEDIUM, size: size) {
                return font
            }
            return UIFont.systemFont(ofSize: size, weight: .semibold)
            
        case .light:
            if let font = UIFont(name: Constants.kW_FONT_SPACEGROTESK_LIGHT, size: size) {
                return font
            }
            return UIFont.systemFont(ofSize: size, weight: .semibold)
        }
    }
}

public extension UIFont {
    static let h1: UIFont = .qFont(weight: .regular, size: 28)
    static let h2: UIFont = .qFont(weight: .regular, size: 22)
    static let paragraph: UIFont = .qFont(weight: .regular, size: 16)
    static let bodySubtitle: UIFont = .qFont(weight: .regular, size: 14)
    static let buttonH1: UIFont = .qFont(weight: .bold, size: 16)
    static let buttonH2: UIFont = .qFont(weight: .bold, size: 14)
    static let textfield: UIFont = .qFont(weight: .regular, size: 14)
}



enum Constants {
    static let kW_FONT_SPACEGROTESK_LIGHT = "SpaceGrotesk-Light"
    static let kW_FONT_SPACEGROTESK_REGULAR = "SpaceGrotesk-Regular"
    static let kW_FONT_SPACEGROTESK_SEMIBOLD = "SpaceGrotesk-SemiBold"
    static let kW_FONT_SPACEGROTESK_MEDIUM = "SpaceGrotesk-Medium"
    static let kW_FONT_SPACEGROTESK_BOLD = "SpaceGrotesk-Bold"
}
