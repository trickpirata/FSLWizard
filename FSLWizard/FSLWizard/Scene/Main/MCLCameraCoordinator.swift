//
//  MCLCameraCoordinator.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 1/30/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import Foundation
import SwiftUI
import Stinsen

final class MCLCameraCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \MCLCameraCoordinator.start)
    
    @Root var start = makeStart
    
    init() {
        
    }
    
    deinit {}
}

extension MCLCameraCoordinator {
    @ViewBuilder func makeStart() -> some View {
        MCLCameraContentView()
    }
}
