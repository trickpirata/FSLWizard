//
//  MCLStyler.swift
//  GeneroUI
//
//  Created by Trick Gorospe on 6/12/21.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import Foundation
import SwiftUI

/// Defines styling constants.
public protocol MCLStyler {
    var color: MCLColorStyler { get }
    var dimension: MCLDimensionStyler { get }
    var appearance: MCLAppearanceStyler { get }
}

/// Defines default values for style constants.
public extension MCLStyler {
    var color: MCLColorStyler { MCLColorStyle() }
    var dimension: MCLDimensionStyler { MCLDimensionStyle() }
    var appearance: MCLAppearanceStyler { MCLAppearanceStyle() }
}

// Concrete object that contains style constants.
public struct MCLStyle: MCLStyler {
    public init() {}
}

private struct StyleEnvironmentKey: EnvironmentKey {
    static var defaultValue: MCLStyler = MCLStyle()
}

public extension EnvironmentValues {

    /// Style constants that can be used by a view.
    var defaultStyle: MCLStyler {
        get { self[StyleEnvironmentKey.self] }
        set { self[StyleEnvironmentKey.self] = newValue }
    }
}

public extension View {

    /// Provide style constants that can be used by a view.
    /// - Parameter style: Style constants that can be used by a view.
    func defaultStyle(_ style: MCLStyler) -> some View {
        return self.environment(\.defaultStyle, style)
    }
}

