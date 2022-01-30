//
//  MCLDimensionsStyler.swift
//  GeneroUI
//
//  Created by Trick Gorospe on 6/12/21.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import UIKit

/// Defines constants for view dimension styling.
public protocol MCLDimensionStyler {

    #if os(iOS)

    var separatorHeight: CGFloat { get }

    #endif

    var lineWidth1: CGFloat { get }
    var stackSpacing1: CGFloat { get }
    
    var horizontalCardPadding: CGFloat { get }
    var verticalCardPadding: CGFloat { get }
    var iconViewPadding: CGFloat { get }
    var textPadding: CGFloat { get }

    var imageHeight2: CGFloat { get }
    var imageHeight1: CGFloat { get }

    var pointSize3: CGFloat { get }
    var pointSize2: CGFloat { get }
    var pointSize1: CGFloat { get }

    var symbolPointSize5: CGFloat { get }
    var symbolPointSize4: CGFloat { get }
    var symbolPointSize3: CGFloat { get }
    var symbolPointSize2: CGFloat { get }
    var symbolPointSize1: CGFloat { get }

    var directionalInsets2: NSDirectionalEdgeInsets { get }
    var directionalInsets1: NSDirectionalEdgeInsets { get }

    var buttonHeight5: CGFloat { get }
    var buttonHeight4: CGFloat { get }
    var buttonHeight3: CGFloat { get }
    var buttonHeight2: CGFloat { get }
    var buttonHeight1: CGFloat { get }
}

/// Default dimension values.
public extension MCLDimensionStyler {

    #if os(iOS)

    var separatorHeight: CGFloat { 1.0 / UIScreen.main.scale }

    #endif

    var lineWidth1: CGFloat { 4 }
    var stackSpacing1: CGFloat { 8 }
    
    var horizontalCardPadding: CGFloat { 6 }
    var verticalCardPadding: CGFloat { 20 }
    var iconViewPadding: CGFloat { 10 }
    var textPadding: CGFloat { 10 }
    
    var imageHeight2: CGFloat { 40 }
    var imageHeight1: CGFloat { 150 }

    var pointSize3: CGFloat { 11 }
    var pointSize2: CGFloat { 14 }
    var pointSize1: CGFloat { 17 }

    var symbolPointSize5: CGFloat { 8 }
    var symbolPointSize4: CGFloat { 12 }
    var symbolPointSize3: CGFloat { 16 }
    var symbolPointSize2: CGFloat { 20 }
    var symbolPointSize1: CGFloat { 30 }

    var directionalInsets2: NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(value: 8)
    }

    var directionalInsets1: NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(value: 16)
    }
    
    var buttonHeight5: CGFloat {
        return 15.0
    }

    var buttonHeight4: CGFloat {
        return 20.0
    }

    var buttonHeight3: CGFloat {
        return 35.0
    }

    var buttonHeight2: CGFloat {
        return 50.0
    }

    var buttonHeight1: CGFloat {
        return 60.0
    }
}

/// Concrete object for dimension constants.
public struct MCLDimensionStyle: MCLDimensionStyler {
    public init() {}
}

private extension NSDirectionalEdgeInsets {
    init(value: CGFloat) {
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }
}
