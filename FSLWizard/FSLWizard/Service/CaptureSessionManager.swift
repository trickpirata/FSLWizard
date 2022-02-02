//
//  CameraService.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 2/2/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import AVFoundation

class CaptureSessionManager: NSObject, ObservableObject {
    enum Status {
        case unconfigured
        case configured
        case unauthorized
        case failed
    }
    
    static let shared = CaptureSessionManager()
    
    @Published var error: CaptureSessionManagerError?
    @Published var current: CVPixelBuffer?
    
    
    let session = AVCaptureSession()
    
    private let sessionQueue = DispatchQueue(label: "ph.edu.mcl.FSLWizard.CaptureSessionQueue")
    private let videoOutputQueue = DispatchQueue(label: "ph.edu.mcl.FSLWizard.VideoOutputQueue",
                                                 qos: .userInitiated,
                                                 attributes: [],
                                                 autoreleaseFrequency: .workItem)
    private var status = Status.unconfigured
    
    private override init() {
        super.init()
        configure()
    }
    
    private func set(error: CaptureSessionManagerError?) {
        DispatchQueue.main.async {
            self.error = error
        }
    }
    
    private func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video) { authorized in
                if !authorized {
                    self.status = .unauthorized
                    self.set(error: .deniedAuthorization)
                }
                self.sessionQueue.resume()
            }
        case .restricted:
            status = .unauthorized
            set(error: .restrictedAuthorization)
        case .denied:
            status = .unauthorized
            set(error: .deniedAuthorization)
        case .authorized:
            break
        @unknown default:
            status = .unauthorized
            set(error: .unknownAuthorization)
        }
    }
    
    private func configureCaptureSession() {
        guard status == .unconfigured else {
            return
        }
        
        session.beginConfiguration()
        
        defer {
            session.commitConfiguration()
        }
        
        let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: .front)
        guard let camera = device else {
            set(error: .cameraUnavailable)
            status = .failed
            return
        }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            if session.canAddInput(cameraInput) {
                session.addInput(cameraInput)
            } else {
                set(error: .cannotAddInput)
                status = .failed
                return
            }
        } catch {
            set(error: .createCaptureInput(error))
            status = .failed
            return
        }
        
        let videoOutput = getVideoDataOutput()
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            
            videoOutput.videoSettings =
            [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            let videoConnection = videoOutput.connection(with: .video)
            videoConnection?.videoOrientation = .portrait
        } else {
            set(error: .cannotAddOutput)
            status = .failed
            return
        }
        
        status = .configured
    }
    
    private func configure() {
        checkPermissions()
        
        sessionQueue.async {
            self.configureCaptureSession()
            self.session.startRunning()
        }
    }
    
    private func getVideoDataOutput() -> AVCaptureVideoDataOutput {
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
        ]
        videoDataOutput.setSampleBufferDelegate(self, queue: videoOutputQueue)
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        return videoDataOutput
    }
}

extension CaptureSessionManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ captureOutput: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        if let buffer = sampleBuffer.imageBuffer {
            DispatchQueue.main.async {
                self.current = buffer
            }
        }
    }
}

