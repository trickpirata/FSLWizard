//
//  MCLCameraViewModel.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 2/2/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import CoreImage

class MCLCameraViewModel: ObservableObject {
    @Published var error: Error?
    @Published var frame: CGImage?
    
    var comicFilter = false
    var monoFilter = false
    var crystalFilter = false
    
    private let context = CIContext()
    
    // private let cameraManager = CaptureSessionManager.shared
    
    init() {
        // setupBinding()
    }
    
    func setupBinding() {
        // swiftlint:disable:next array_init
//        cameraManager.$error
//            .receive(on: RunLoop.main)
//            .map { $0 }
//            .assign(to: &$error)
//        
//        cameraManager.$current
//            .receive(on: RunLoop.main)
//            .compactMap { buffer -> CGImage? in
//                guard let image = CGImage.create(from: buffer) else {
//                    return nil
//                }
//                
//                let ciImage = CIImage(cgImage: image)
//                
//                return self.context.createCGImage(ciImage, from: ciImage.extent)
//            }
//            .assign(to: &$frame)
    }
}
