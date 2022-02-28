//
//  MCLCameraView.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 2/2/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import SwiftUI

struct MCLCameraView: UIViewControllerRepresentable {
    var pointsProcessorHandler: (([CGPoint]) -> Void)?
    var predictions:((String) -> Void)?
    
    func makeUIViewController(context: Context) -> MCLCameraViewController {
        let cvc = MCLCameraViewController()
        cvc.pointsProcessorHandler = pointsProcessorHandler
        return cvc
    }
    
    func updateUIViewController(
        _ uiViewController: MCLCameraViewController,
        context: Context
    ) {
    }
}

