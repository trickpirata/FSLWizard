//
//  MCLMainCoordinator.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 1/30/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import Foundation
import SwiftUI
import Stinsen

final class MCLMainCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \MCLMainCoordinator.start)
    
    @Root var start = makeStart
    @Root var camera = makeCamera
    
    init() {}
    
    deinit {}
}

extension MCLMainCoordinator {
    @ViewBuilder func makeStart() -> some View {
        MCLSplashContentView()
    }
    
    func makeCamera() -> MCLTabCoordinator {
        return MCLTabCoordinator()
    }
}
