//
//  MCLPracticeViewController.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 6/1/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import UIKit
import AVFoundation
import Vision
import Combine

final class MCLPracticeViewController: UIViewController {
    private var cameraView: MCLPracticeCameraPreview { view as! MCLPracticeCameraPreview }
    var viewModel: MCLPracticeViewModel!
    
    var pointsProcessorHandler: (([Pose]?) -> Void)?
    var prediction: ((String) -> Void)?
    var previewContext: ((UIImage) -> Void)?
    var selectedType: MCLDataType = .alphabet {
        didSet {
            viewModel.classifierType = selectedType
        }
    }
    private var cancellable: Set<AnyCancellable> = []
    
    override func loadView() {
        view = MCLPracticeCameraPreview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.cameraManager.session.startRunning()
        setupFeed()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.cameraManager.session.stopRunning()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    private func setupFeed() {
        cameraView.previewLayer.session = viewModel.cameraManager.session
        cameraView.previewLayer.videoGravity = .resizeAspectFill
    }
    
    private func drawPoses(_ poses: [Pose]?, onto frame: CGImage) {
        // Create a default render format at a scale of 1:1.
        let renderFormat = UIGraphicsImageRendererFormat()
        renderFormat.scale = 1.0

        // Create a renderer with the same size as the frame.
        let frameSize = CGSize(width: frame.width, height: frame.height)
        let poseRenderer = UIGraphicsImageRenderer(size: frameSize,
                                                   format: renderFormat)

        // Draw the frame first and then draw pose wireframes on top of it.
        let frameWithPosesRendering = poseRenderer.image { rendererContext in
            // The`UIGraphicsImageRenderer` instance flips the Y-Axis presuming
            // we're drawing with UIKit's coordinate system and orientation.
            let cgContext = rendererContext.cgContext

            // Get the inverse of the current transform matrix (CTM).
            let inverse = cgContext.ctm.inverted()

            // Restore the Y-Axis by multiplying the CTM by its inverse to reset
            // the context's transform matrix to the identity.
            cgContext.concatenate(inverse)

            // Draw the camera image first as the background.
            let imageRectangle = CGRect(origin: .zero, size: frameSize)
            cgContext.draw(frame, in: imageRectangle)

            // Create a transform that converts the poses' normalized point
            // coordinates `[0.0, 1.0]` to properly fit the frame's size.
            let pointTransform = CGAffineTransform(scaleX: frameSize.width,
                                                   y: frameSize.height)

            guard let poses = poses else { return }

            // Draw all the poses Vision found in the frame.
            for pose in poses {
                // Draw each pose as a wireframe at the scale of the image.
                pose.drawWireframeToContext(cgContext, applying: pointTransform)
            }
        }

        // Update the UI's full-screen image view on the main thread.
        DispatchQueue.main.async {
            self.previewContext?(frameWithPosesRendering)
        }
    }
}

extension MCLPracticeViewController: MCLPracticeViewModelDelegate {
    func viewModelProcessAlphabet(didDetect observations: [VNObservation]?) {
        guard let observations = observations else {
            return
        }
        for observation in observations where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                continue
            }
            
            // Select only the label with the highest confidence.
            let topLabelObservation = objectObservation.labels[0]
            let alphabet = topLabelObservation.identifier
            
            self.viewModel.alphabetPrediction.send(alphabet)
            self.prediction?(alphabet)
        }
    }
    
    func viewModelProcessing(didDetect poses: [Pose]?, in frame: CGImage) {
        // Render the poses on a different queue than pose publisher.
        DispatchQueue.global(qos: .userInteractive).async {
            // Draw the poses onto the frame.
            self.drawPoses(poses, onto: frame)
        }
    }
}

