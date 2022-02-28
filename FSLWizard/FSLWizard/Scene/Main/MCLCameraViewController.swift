//
//  MCLCameraViewController.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 2/2/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

final class MCLCameraViewController: UIViewController {
    private var cameraView: MCLCameraPreview { view as! MCLCameraPreview }
    
    private let videoDataOutputQueue = DispatchQueue(
        label: "CameraFeedOutput",
        qos: .userInteractive
    )
    private var cameraFeedSession: AVCaptureSession?
    private let handPoseRequest: VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 2
        return request
    }()
    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let configuration = MLModelConfiguration()
            let aslClassifier = try ASL_Classifier(configuration: configuration)
            let model = try VNCoreMLModel(for: aslClassifier.model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
//                if let results = request.results {
//                    self?.processPrediction(results)
//                }
            })
            
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    private var detectionOverlay: CALayer! = nil
    
    var pointsProcessorHandler: (([CGPoint]) -> Void)?
    var prediction: ((String) -> Void)?
    
    override func loadView() {
        view = MCLCameraPreview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            if cameraFeedSession == nil {
                try setupAVSession()
                cameraView.previewLayer.session = cameraFeedSession
                cameraView.previewLayer.videoGravity = .resizeAspectFill
            }
            cameraFeedSession?.startRunning()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewWillDisappear(animated)
    }
    
    func setupAVSession() throws {
        // Select a front facing camera, make an input.
        guard let videoDevice = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front)
        else {
            throw CaptureSessionManagerError.cameraUnavailable
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(
            device: videoDevice
        ) else {
            throw CaptureSessionManagerError.cameraUnavailable
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high
        
        // Add a video input.
        guard session.canAddInput(deviceInput) else {
            throw CaptureSessionManagerError.cameraUnavailable
        }
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            // Add a video data output.
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            throw CaptureSessionManagerError.cameraUnavailable
        }
        session.commitConfiguration()
        cameraFeedSession = session
    }
    
    func processPoints(_ fingerTips: [CGPoint]) {
        // Convert points from AVFoundation coordinates to UIKit coordinates.
        let convertedPoints = fingerTips.map {
            cameraView.previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
        }
        pointsProcessorHandler?(convertedPoints)
    }
    
    func processPrediction(_ results: [VNObservation]) {
//        CATransaction.begin()
//        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
//        detectionOverlay.sublayers = nil // remove all the old recognized signs
        if let topLabelObservation = results.sorted(by: {$0.confidence > $1.confidence }).first as? VNRecognizedObjectObservation, let first = topLabelObservation.labels.first {
            prediction?("\(first.identifier), \(first.confidence.description)")
            print("\(first.identifier), \(first.confidence.description)")
        }
        
//        for observation in results where observation is VNRecognizedObjectObservation {
//            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
//                continue
//            }
//
//            // Select only the label with the highest confidence.
//            //sort via confidence
//
//            let topLabelObservation = objectObservation.labels[0]
////            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
////
////            let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
//
////            let textLayer = self.createTextSubLayerInBounds(objectBounds,
////                                                            predictedResult: topLabelObservation.identifier,
////                                                            confidence: topLabelObservation.confidence)
////            shapeLayer.addSublayer(textLayer)
////            detectionOverlay.addSublayer(shapeLayer)
//
//
////            textLabel.text = topLabelObservation.identifier

//
//        }
//        self.updateLayerGeometry()
//        CATransaction.commit()
    }
    
    func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
}

extension MCLCameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                    return
                }
        var fingerTips: [CGPoint] = []
        var predictions: [VNObservation] = []
        
        defer {
            DispatchQueue.main.sync {
                self.processPoints(fingerTips)
                self.processPrediction(predictions)
            }
        }
        
//        let handler = VNImageRequestHandler(
//            cmSampleBuffer: sampleBuffer,
//            orientation: .up,
//            options: [:]
//        )
        let exifOrientation = exifOrientationFromDeviceOrientation()
                
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
        do {
            try handler.perform([classificationRequest])
            
            // No hands detected
//            guard let handResult = handPoseRequest.results?.prefix(2), !handResult.isEmpty else {
//                return
//            }
//
//            var recognizedPoints: [VNRecognizedPoint] = []
//
//            try handResult.forEach { observation in
//                // Get points for all fingers.
//                let fingers = try observation.recognizedPoints(.all)
//
//                // Look for tip points.
//                if let thumbTipPoint = fingers[.thumbTip] {
//                    recognizedPoints.append(thumbTipPoint)
//                }
//                if let indexTipPoint = fingers[.indexTip] {
//                    recognizedPoints.append(indexTipPoint)
//                }
//                if let middleTipPoint = fingers[.middleTip] {
//                    recognizedPoints.append(middleTipPoint)
//                }
//                if let ringTipPoint = fingers[.ringTip] {
//                    recognizedPoints.append(ringTipPoint)
//                }
//                if let littleTipPoint = fingers[.littleTip] {
//                    recognizedPoints.append(littleTipPoint)
//                }
//            }
//
//            fingerTips = recognizedPoints.filter {
//                // Ignore low confidence points.
//                $0.confidence > 0.9
//            }
//            .map {
//                // Convert points from Vision coordinates to AVFoundation coordinates.
//                CGPoint(x: $0.location.x, y: 1 - $0.location.y)
//            }
            
            guard let modelResult = classificationRequest.results, !modelResult.isEmpty else {
                return
            }

            predictions = modelResult.filter { $0.confidence > 0.8 }
            
        } catch {
            cameraFeedSession?.stopRunning()
            print(error.localizedDescription)
        }
    }
}

