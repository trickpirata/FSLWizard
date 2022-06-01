//
//  MCLCameraView.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 6/1/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import SwiftUI

struct MCLPracticeCameraView: UIViewControllerRepresentable {
    var pointsProcessorHandler: (([Pose]?) -> Void)?
    var predictions:((String) -> Void)?
    var imageOverlay:((UIImage) -> Void)?
    var selectedType: MCLDataType = .alphabet
    var viewModel: MCLPracticeViewModel
    
    func makeUIViewController(context: Context) -> MCLPracticeViewController {
        let cvc = MCLPracticeViewController()
        cvc.viewModel = viewModel
        cvc.pointsProcessorHandler = pointsProcessorHandler
        cvc.prediction = predictions
        cvc.selectedType = selectedType
        cvc.previewContext = imageOverlay
        return cvc
    }
    
    func updateUIViewController(
        _ uiViewController: MCLPracticeViewController,
        context: Context
    ) {
        if uiViewController.selectedType != self.selectedType {
            uiViewController.selectedType = self.selectedType
        }
    }
}
