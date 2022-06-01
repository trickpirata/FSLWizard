//
//  MCLVideoPlayer.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 3/4/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import SwiftUI
import AVKit

struct MCLVideoPlayer: View {
    var videoName: String
    @StateObject private var viewModel = MCLVideoListViewModel()
    
    var body: some View {
        VStack {
            VideoPlayer(player: AVPlayer(url:  Bundle.main.url(forResource: videoName, withExtension: "mp4")!))
                .frame(height: 400)
            Spacer()
        }.navigationTitle(videoName.firstUppercased)
    }
}

#if DEBUG
struct MCLVideoPlayer_Previews: PreviewProvider {
    static var previews: some View {
        MCLVideoPlayer(videoName: "africa")
    }
}
#endif
