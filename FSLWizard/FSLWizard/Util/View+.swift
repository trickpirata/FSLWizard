//
//  View+.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 3/3/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import SwiftUI

extension View {
    /// Conditionally apply modifiers to a view.
    func `if`<TrueContent: View>(_ condition: Bool, trueContent: (Self) -> TrueContent) -> some View {
        condition ?
            ViewBuilder.buildEither(first: trueContent(self)) :
            ViewBuilder.buildEither(second: self)
    }
    
    /// Sets the text color for a navigation bar title.
    /// - Parameter color: Color the title should be
    ///
    /// Supports both regular and large titles.
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
    
        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
    
        return self
    }
}
