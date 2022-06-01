//
//  MCLPracticeCoordinator.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 6/1/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import Foundation
import SwiftUI
import Stinsen

final class MCLPracticeCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \MCLPracticeCoordinator.start)
    
    @Root var start = makeStart
    @Route(.push) var practice = makePractice
    
    init() {
        
    }
    
    deinit {}
}

extension MCLPracticeCoordinator {
    @ViewBuilder func makeStart() -> some View {
        MCLPracticeListContentView()
    }
    
    @ViewBuilder func makePractice(forAction action: ActionPrediction) -> some View {
        MCLPracticeContentView(withAction: action)
    }

}
