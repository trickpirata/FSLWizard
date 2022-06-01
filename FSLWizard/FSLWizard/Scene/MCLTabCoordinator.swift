//
//  MCLTabCoordinator.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 3/4/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import Foundation
import SwiftUI
import Stinsen

final class MCLTabCoordinator: TabCoordinatable {
    var child = TabChild(
        startingItems: [
            \MCLTabCoordinator.camera,
            \MCLTabCoordinator.catalogue,
            \MCLTabCoordinator.practice,
            \MCLTabCoordinator.about
        ]
    )
    
    @Route(tabItem: makeCameraTab) var camera = makeCamera
    @Route(tabItem: makeCatalogueTab) var catalogue = makeCatalogue
    @Route(tabItem: makePracticeTab) var practice = makePractice
    @Route(tabItem: makeAboutTab) var about = makeAbout
    
    init() {
    }
    
    deinit {
        print("Deinit")
    }
}

extension MCLTabCoordinator {
    func makeCamera() -> MCLCameraCoordinator {
        return MCLCameraCoordinator()
    }
    
    @ViewBuilder func makeCameraTab(isActive: Bool) -> some View {
        Image(systemName: "camera" + (isActive ? ".fill" : ""))
        Text("Vision")
    }
    
    func makeCatalogue() -> MCLVideoListCoordinator {
        return MCLVideoListCoordinator()
    }
    
    @ViewBuilder func makeCatalogueTab(isActive: Bool) -> some View {
        Image(systemName: "books.vertical" + (isActive ? ".fill" : ""))
        Text("Catalogue")
    }
    
    func makePractice() -> NavigationViewCoordinator<MCLPracticeCoordinator> {
        return NavigationViewCoordinator(MCLPracticeCoordinator())
    }
    
    @ViewBuilder func makePracticeTab(isActive: Bool) -> some View {
        Image(systemName: isActive ? "video.fill.badge.checkmark" : "video.badge.checkmark")
        Text("Practice")
    }
    
    func makeAbout() -> MCLAboutCoordinator {
        return MCLAboutCoordinator()
    }
    
    @ViewBuilder func makeAboutTab(isActive: Bool) -> some View {
        Image(systemName: "questionmark.circle" + (isActive ? ".fill" : ""))
        Text("About")
    }
}
