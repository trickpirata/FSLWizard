//
//  MCLPracticeContentView.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 6/1/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import SwiftUI
import FSLWizardUI
import Stinsen
import Combine

struct MCLPracticeContentView: View {
    @Environment(\.defaultStyle) private var style
    @Environment(\.presentationMode) var presentation

    @State private var overlayPoints: [Pose]?
    @State private var classification: String = "N/A"
    @State private var imageOverlay: Image?
    @State private var selectedType: Int = 0
    @StateObject private var viewModel: MCLPracticeViewModel = MCLPracticeViewModel()
    
    //MARK: Input
    private let btnCameraSwitchTapSubject = PassthroughSubject<Void, Never>()
    private let predictionToPractice: ActionPrediction
    private var cancelBag = Set<AnyCancellable>()
    
    init(withAction action: ActionPrediction) {
        predictionToPractice = action
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                style.color.secondaryCustomBackground.suColor.ignoresSafeArea()
                MCLPracticeCameraView(pointsProcessorHandler: {
                    overlayPoints = $0
                }, predictions: {
                    classification = $0
                }, imageOverlay: {
                    imageOverlay = Image(uiImage: $0)
                }, selectedType: .phrases,
                              viewModel: viewModel)
                .overlay(
                    imageOverlay?
                        .resizable()
                        .scaledToFill()
                ).onAppear(perform: {
                    let input = MCLPracticeViewModel.Input(didChangeCamera: btnCameraSwitchTapSubject.eraseToAnyPublisher())
                    viewModel.setupBinding(input)
                    viewModel.continuePredicting = true
                    viewModel.currentPrediction = predictionToPractice
                }).onDisappear(perform: {
                    viewModel.continuePredicting = false
                })
                .edgesIgnoringSafeArea(.top)
                .alert(isPresented: $viewModel.loaderCompleted) {
                    Alert(title: Text("You got it!"),
                        message: Text("You can do \(predictionToPractice.label)!"),
                        dismissButton: Alert.Button.default(
                            Text("Continue"), action: { presentation.wrappedValue.dismiss() }
                        )
                    )
                }
                
                VStack {
                    Spacer()
                    MCLLoadingView(startLoading: $viewModel.startLoading, completed: $viewModel.loaderCompleted)
                }.onAppear(perform: {
                    
                })
            }
        }
    }
}

#if DEBUG
struct MCLPracticeContentView_Previews: PreviewProvider {
    static var previews: some View {
        MCLPracticeContentView(withAction: ActionPrediction(action: .apple, confidence: 100.0))
    }
}
#endif
