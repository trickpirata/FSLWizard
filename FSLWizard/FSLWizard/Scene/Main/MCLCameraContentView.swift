//
//  MCLCameraContentView.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 1/30/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import SwiftUI
import Combine

struct MCLCameraContentView: View {
    @State private var overlayPoints: [Pose]?
    @State private var classification: String = "N/A"
    @State private var imageOverlay: Image?
    @State private var selectedType: Int = 0
    @StateObject private var viewModel: MCLCameraViewModel = MCLCameraViewModel()
    
    var image: CGImage?

    private let label = Text("Capture feed")
    private let btnCameraSwitchTapSubject = PassthroughSubject<Void, Never>()
    
    var body: some View {
        ZStack {
            MCLCameraView(pointsProcessorHandler: {
                overlayPoints = $0
            }, predictions: {
                classification = $0
            }, imageOverlay: {
                imageOverlay = Image(uiImage: $0)
            }, selectedType: MCLDataType(rawValue: selectedType) ?? .alphabet,
                          viewModel: viewModel)
            .overlay(
                imageOverlay?
                    .resizable()
                    .scaledToFill()
            ).onAppear(perform: {
                viewModel.continuePredicting = true
                let input = MCLCameraViewModel.Input(didChangeCamera: btnCameraSwitchTapSubject.eraseToAnyPublisher())
                viewModel.setupBinding(input)
            }).onDisappear(perform: {
                viewModel.continuePredicting = false
            })
            .edgesIgnoringSafeArea(.top)

            VStack {
                HStack {
                    Spacer()
                    Button {
                        btnCameraSwitchTapSubject.send()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                            .tint(.white)
                    }
                }.padding()
                Spacer()
            }
            VStack(alignment: .center) {
                Spacer()
                Text(selectedType == 0 ? classification : viewModel.prediction?.label ?? "")
                    .font(.system(size: 80))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Picker("Select detection type", selection: $selectedType) {
                    Text("Alphabet").tag(0)
                    Text("Phrases").tag(1)
                }.padding()
                .pickerStyle(.segmented)
            }.background(Color.clear)
        }
    }
}

#if DEBUG
struct MCLCameraContentView_Previews: PreviewProvider {
    static var previews: some View {
        MCLCameraContentView()
    }
}
#endif
