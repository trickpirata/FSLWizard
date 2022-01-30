//
//  MCLColorStyler.swift
//  GeneroUI
//
//  Created by Trick Gorospe on 6/12/21.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import UIKit

/// Defines color constants.
public protocol MCLColorStyler {

    #if os(iOS)

    var label: UIColor { get }
    var secondaryLabel: UIColor { get }
    var tertiaryLabel: UIColor { get }
    var heroLabel: UIColor { get }
    
    var separator: UIColor { get }

    var customFill: UIColor { get }
    var secondaryCustomFill: UIColor { get }
    var tertiaryCustomFill: UIColor { get }
    var quaternaryCustomFill: UIColor { get }

    var customBlue: UIColor { get }

    var customGray: UIColor { get }
    var customGray2: UIColor { get }
    var customGray3: UIColor { get }
    var customGray4: UIColor { get }
    var customGray5: UIColor { get }

    #endif

    var white: UIColor { get }
    var black: UIColor { get }
    var clear: UIColor { get }

    var customBackground: UIColor { get }
    var primaryCustomBackground: UIColor { get }
    var secondaryCustomBackground: UIColor { get }
    
    var buttonColor1: UIColor { get }
    var buttonColor2: UIColor { get }
    var buttonColor3: UIColor { get }
    var buttonColor4: UIColor { get }

    var customGroupedBackground: UIColor { get }
    var secondaryCustomGroupedBackground: UIColor { get }
    var tertiaryCustomGroupedBackground: UIColor { get }
    
    var mainGradientBackgroundColors: [UIColor] { get }
    var greenGradientBackgroundColors: [UIColor] { get }
    var violetGradientBackgroundColors: [UIColor] { get }
    var blueGradientBackgroundColors: [UIColor] { get }
    var grayGradientBackgroundColors: [UIColor] { get }
    
}

/// Defines default values for color constants.
public extension MCLColorStyler {

    var label: UIColor { .label }
    var secondaryLabel: UIColor { .secondaryLabel }
    var tertiaryLabel: UIColor { .tertiaryLabel }
    var heroLabel: UIColor { UIColor(red: 0.514, green: 0.200, blue: 1.000, alpha: 1.00) }
    var separator: UIColor { .separator }

    var customBackground: UIColor { .systemBackground }
    var primaryCustomBackground: UIColor { UIColor(red: 0.094, green: 0.151, blue: 0.321, alpha: 1.00) }
    var secondaryCustomBackground: UIColor { UIColor(red: 0.891, green: 0.931, blue: 0.969, alpha: 1.00) }

    var buttonColor1: UIColor { UIColor(red: 46.0/255.0, green: 123.0/255.0, blue: 232.0/255.0, alpha: 1.0) }
    var buttonColor2: UIColor { .white }
    var buttonColor3: UIColor { UIColor(red: 64.0/255.0, green: 94.0/255.0, blue: 255.0/255.0, alpha: 1.0)}
    var buttonColor4: UIColor { UIColor(red: 71.0/255.0, green: 93.0/255.0, blue: 245.0/255.0, alpha: 1.0)}

    var customGroupedBackground: UIColor { .systemGroupedBackground }
    var secondaryCustomGroupedBackground: UIColor { .secondarySystemGroupedBackground }
    var tertiaryCustomGroupedBackground: UIColor { .tertiarySystemGroupedBackground }

    var customFill: UIColor { .tertiarySystemFill }
    var secondaryCustomFill: UIColor { .secondarySystemFill }
    var tertiaryCustomFill: UIColor { .tertiarySystemFill }
    var quaternaryCustomFill: UIColor { .quaternarySystemFill }

    var customBlue: UIColor { .systemBlue }

    var customGray: UIColor { .systemGray }
    var customGray2: UIColor { .systemGray2 }
    var customGray3: UIColor { .systemGray3 }
    var customGray4: UIColor { .systemGray4 }
    var customGray5: UIColor { .systemGray5 }
    var customGray6: UIColor { UIColor(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.00) }
    var customVerticalCard: UIColor { UIColor(red: 0.249, green: 0.368, blue: 1.000, alpha: 1.00) }

    var white: UIColor { .white }
    var black: UIColor { .black }
    var clear: UIColor { .clear }

    var mainGradientBackgroundColors: [UIColor] { [UIColor(red: 0.251, green: 0.369, blue: 1.000, alpha: 1.00), UIColor(red: 0.200, green: 0.741, blue: 1.000, alpha: 1.00)] }
    var greenGradientBackgroundColors: [UIColor] { [UIColor(red: 0.094, green: 0.690, blue: 0.220, alpha: 1.00), UIColor(red: 0.200, green: 0.741, blue: 1.000, alpha: 1.00)] }
    var violetGradientBackgroundColors: [UIColor] { [UIColor(red: 131.0/255.0, green: 51.0/255.0, blue: 1.0, alpha: 1.00), UIColor(red: 0.200, green: 0.741, blue: 1.000, alpha: 1.00)] }
    var blueGradientBackgroundColors: [UIColor] { [UIColor(red: 51.0/255.0, green: 189.0/255.0, blue: 1.0, alpha: 1.00), UIColor(red: 64.0/255.0, green:94.0/255.0, blue: 1.0, alpha: 1.00)] }
    var grayGradientBackgroundColors: [UIColor] { [UIColor(red: 0, green: 0, blue: 0, alpha: 0.36), UIColor(red: 0, green: 0, blue: 0, alpha: 1.00)] }
}

/// Concrete object for color constants.
public struct MCLColorStyle: MCLColorStyler {
    public init() {}
}
