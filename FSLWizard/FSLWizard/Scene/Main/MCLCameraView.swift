//
//  MCLCameraView.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 2/2/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import SwiftUI

enum MCLDataType: Int {
    case alphabet = 0
    case phrases
}
struct MCLCameraView: UIViewControllerRepresentable {
    var pointsProcessorHandler: (([Pose]?) -> Void)?
    var predictions:((String) -> Void)?
    var imageOverlay:((UIImage) -> Void)?
    var selectedType: MCLDataType = .alphabet
    var viewModel: MCLCameraViewModel
    
    func makeUIViewController(context: Context) -> MCLCameraViewController {
        let cvc = MCLCameraViewController()
        cvc.viewModel = viewModel
        cvc.pointsProcessorHandler = pointsProcessorHandler
        cvc.prediction = predictions
        cvc.selectedType = selectedType
        cvc.previewContext = imageOverlay
        return cvc
    }
    
    func updateUIViewController(
        _ uiViewController: MCLCameraViewController,
        context: Context
    ) {
        if uiViewController.selectedType != self.selectedType {
            uiViewController.selectedType = self.selectedType
        }
    }
}

