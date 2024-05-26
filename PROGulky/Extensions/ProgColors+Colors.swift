//
//  ProgColors+Colors.swift
//  PROGulky
//
//  Created by Иван Тазенков on 25.11.2022.
//

import Foundation
import UIKit

// MARK: - ProgColors

struct ProgColors {}

private extension ProgColors {
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark ? dark : light
        })
    }
}

extension ProgColors {
    // MARK: - Палитра динамических цветов

    public enum Dynamic {
        static let lightText: UIColor = dynamicColor(light: lightTextL, dark: lightTextD)
        static let text: UIColor = dynamicColor(light: textL, dark: textD)
        static let background: UIColor = dynamicColor(light: backgroundL, dark: backgroundD)
        static let background2: UIColor = dynamicColor(light: background2L, dark: background2D)
        static let lightBackground: UIColor = dynamicColor(light: lightBackgroundL, dark: lightBackgroundD)
        static let primary: UIColor = dynamicColor(light: primaryL, dark: primaryD)
        static let lightPrimary: UIColor = dynamicColor(light: lightPrimaryL, dark: lightPrimaryD)
        static let success: UIColor = dynamicColor(light: successL, dark: successD)
        static let danger: UIColor = dynamicColor(light: dangerL, dark: dangerD)
        static let warning: UIColor = dynamicColor(light: warningL, dark: warningD)
        static let base: UIColor = dynamicColor(light: baseL, dark: baseD)
        static let shadow: UIColor = dynamicColor(light: shadowL, dark: shadowD)
        static let shadowProfile: UIColor = dynamicColor(light: shadowL, dark: noShadow)
        static let textGray: UIColor = dynamicColor(light: textGrayL, dark: textGrayD)
        static let rating: UIColor = dynamicColor(light: ratingL, dark: ratingD)

        static let greetingText: UIColor = dynamicColor(light: primaryL, dark: textD) // Цвет приветственного слова "Привет"
    }
}

// MARK: - Вообще все цвета

private extension ProgColors {
    static var lightTextL: UIColor { UIColor(red: 0.678, green: 0.670, blue: 0.698, alpha: 1) }
    static var lightTextD: UIColor { UIColor(red: 0.341, green: 0.337, blue: 0.356, alpha: 1) }

    static var textL: UIColor { UIColor(red: 0, green: 0, blue: 0, alpha: 1) }
    static var textD: UIColor { UIColor(red: 1, green: 1, blue: 1, alpha: 1) }

    static var backgroundL: UIColor { UIColor(red: 1, green: 1, blue: 1, alpha: 1) }
    static var backgroundD: UIColor { UIColor(red: 0.137, green: 0.113, blue: 0.149, alpha: 1) }

	static var background2L: UIColor { UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1) }
	static var background2D: UIColor { UIColor(red: 0.137, green: 0.113, blue: 0.149, alpha: 1) }


    static var lightBackgroundL: UIColor { UIColor(red: 1, green: 1, blue: 1, alpha: 1) }
    static var lightBackgroundD: UIColor { UIColor(red: 0.227, green: 0.196, blue: 0.243, alpha: 1) }

    static var primaryL: UIColor { UIColor(red: 0.29, green: 0.403, blue: 1, alpha: 1) }
    static var primaryD: UIColor { UIColor(red: 0.29, green: 0.403, blue: 1, alpha: 1) }

    static var lightPrimaryL: UIColor { UIColor(red: 0.44, green: 0.583, blue: 0.433, alpha: 1) }
    static var lightPrimaryD: UIColor { UIColor(red: 0.543, green: 0.688, blue: 0.536, alpha: 1) }

    static var successL: UIColor { UIColor(red: 0.204, green: 0.78, blue: 0.349, alpha: 1) }
    static var successD: UIColor { UIColor(red: 0.375, green: 0.85, blue: 0.495, alpha: 1) }

    static var dangerL: UIColor { UIColor(red: 0.898, green: 0.133, blue: 0.063, alpha: 1) }
    static var dangerD: UIColor { UIColor(red: 0.904, green: 0.376, blue: 0.328, alpha: 1) }

    static var warningL: UIColor { UIColor(red: 0.976, green: 0.659, blue: 0.141, alpha: 1) }
    static var warningD: UIColor { UIColor(red: 0.975, green: 0.74, blue: 0.358, alpha: 1) }

    static var baseL: UIColor { UIColor(red: 0, green: 0.478, blue: 1, alpha: 1) }
    static var baseD: UIColor { UIColor(red: 0.188, green: 0.576, blue: 1, alpha: 1) }

    static var shadowL: UIColor { UIColor(red: 0.69, green: 0.69, blue: 0.69, alpha: 1) }
    static var shadowD: UIColor { UIColor(red: 0.125, green: 0.098, blue: 0.137, alpha: 1) }
    static var noShadow: UIColor { UIColor(red: 0.137, green: 0.113, blue: 0.149, alpha: 1) }

    static var textGrayL: UIColor { UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1) }
    static var textGrayD: UIColor { UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1) }

    static var ratingL: UIColor { UIColor(red: 0.988, green: 0.819, blue: 0.164, alpha: 1) }
    static var ratingD: UIColor { UIColor(red: 0.988, green: 0.819, blue: 0.164, alpha: 1) }
}
