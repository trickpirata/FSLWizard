//
//  MCLAboutCoordinator.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 6/1/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import Foundation
import SwiftUI
import Stinsen

final class MCLAboutCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \MCLAboutCoordinator.start)
    
    @Root var start = makeStart
    
    init() {
        
    }
    
    deinit {}
}

extension MCLAboutCoordinator {
    @ViewBuilder func makeStart() -> some View {
        MCLAboutContentView()
    }
}
