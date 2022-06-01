//
//  MCLVideoListCoordinator.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 3/4/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import Foundation
import SwiftUI
import Stinsen

final class MCLVideoListCoordinator: NavigationCoordinatable {
    let stack = NavigationStack(initial: \MCLVideoListCoordinator.start)
    
    @Root var start = makeStart
    @Route(.modal) var videoPlayer = makeVideoPlayer
    
    init() {
        
    }
    
    deinit {}
}

extension MCLVideoListCoordinator {
    @ViewBuilder func makeStart() -> some View {
        MCLVideoListContentView()
    }
    
    @ViewBuilder func makeVideoPlayer(video: String) -> some View {
        MCLVideoPlayer(videoName: video)
    }
}
