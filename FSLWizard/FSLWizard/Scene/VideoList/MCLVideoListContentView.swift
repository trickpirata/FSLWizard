//
//  VideoListContentView.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 3/2/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import SwiftUI
import AVKit
import Stinsen

struct MCLVideoListContentView: View {
    @EnvironmentObject private var router: MCLVideoListCoordinator.Router
    @StateObject private var viewModel = MCLVideoListViewModel()
    
    var body: some View {
        List(viewModel.videoList, id: \.id) { video in
            Button {
                router.route(to: \.videoPlayer, video.title)
            } label: {
                HStack {
                    HStack {
                        if let image = viewModel.createThumbnail(for: video.title) {
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .cornerRadius(4)
                                .padding(.vertical, 4)
                        }
                        
                        VStack(alignment: .leading, spacing: 5, content: {
                            Text(video.title)
                                .fontWeight(.semibold)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                        })
                    }
                    Spacer()
                    Image(systemName: "chevron.right").padding()
                }
            }
            .buttonStyle(NoHighlightStyle())
        }.navigationTitle("Catalogue")
    }
}

#if DEBUG
struct MCLVideoListContentView_Previews: PreviewProvider {
    static var previews: some View {
        MCLVideoListContentView()
    }
}
#endif
