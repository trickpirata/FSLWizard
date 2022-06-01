//
//  MCLPracticeListContentView.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 6/1/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import SwiftUI
import Stinsen

struct MCLPracticeListContentView: View {
    @EnvironmentObject private var router: MCLPracticeCoordinator.Router
    @StateObject private var viewModel = MCLPracticeListViewModel()
    
    var body: some View {
        List(viewModel.videoList, id: \.id) { video in
            Button {
                router.route(to: \.practice, ActionPrediction(action: PhrasesClassifierHand.Action(rawValue: video.title) ?? .unknown, confidence: 100.0))
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
        }.navigationTitle("Practice List")
    }
}

#if DEBUG
struct MCLPracticeListContentView_Previews: PreviewProvider {
    static var previews: some View {
        MCLPracticeListContentView()
    }
}
#endif
