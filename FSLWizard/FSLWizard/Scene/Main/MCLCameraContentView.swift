//
//  MCLCameraContentView.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 1/30/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import SwiftUI

struct MCLCameraContentView: View {
    @State private var overlayPoints: [CGPoint] = []
    @StateObject private var model = MCLCameraViewModel()
    
    var image: CGImage?

    private let label = Text("Capture feed")
    var body: some View {
        ZStack {
            MCLCameraView {
              overlayPoints = $0
            }
            .overlay(
              FingersOverlay(with: overlayPoints)
                .foregroundColor(.red)
            )
        }.edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct MCLCameraContentView_Previews: PreviewProvider {
    static var previews: some View {
        MCLCameraContentView()
    }
}
#endif
