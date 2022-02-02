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
    
    var pointsProcessorHandler: (([CGPoint]) -> Void)?
    
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
}

extension MCLCameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        var fingerTips: [CGPoint] = []
        
        defer {
            DispatchQueue.main.sync {
                self.processPoints(fingerTips)
            }
        }
        
        let handler = VNImageRequestHandler(
            cmSampleBuffer: sampleBuffer,
            orientation: .up,
            options: [:]
        )
        do {
            // Perform VNDetectHumanHandPoseRequest
            try handler.perform([handPoseRequest])
            
            // Continue only when at least a hand was detected in the frame. We're interested in maximum of two hands.
            guard
                let results = handPoseRequest.results?.prefix(2),
                !results.isEmpty
            else {
                return
            }
            
            var recognizedPoints: [VNRecognizedPoint] = []
            
            try results.forEach { observation in
                // Get points for all fingers.
                let fingers = try observation.recognizedPoints(.all)
                
                // Look for tip points.
                if let thumbTipPoint = fingers[.thumbTip] {
                    recognizedPoints.append(thumbTipPoint)
                }
                if let indexTipPoint = fingers[.indexTip] {
                    recognizedPoints.append(indexTipPoint)
                }
                if let middleTipPoint = fingers[.middleTip] {
                    recognizedPoints.append(middleTipPoint)
                }
                if let ringTipPoint = fingers[.ringTip] {
                    recognizedPoints.append(ringTipPoint)
                }
                if let littleTipPoint = fingers[.littleTip] {
                    recognizedPoints.append(littleTipPoint)
                }
            }
            
            fingerTips = recognizedPoints.filter {
                // Ignore low confidence points.
                $0.confidence > 0.9
            }
            .map {
                // Convert points from Vision coordinates to AVFoundation coordinates.
                CGPoint(x: $0.location.x, y: 1 - $0.location.y)
            }
        } catch {
            cameraFeedSession?.stopRunning()
            print(error.localizedDescription)
        }
    }
}

