//
//  MCLPracticeViewModel.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 6/1/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import Foundation
import CoreImage
import Vision
import Combine
import AVFoundation

struct PredictionPracticeResult {
    var prediction: ActionPrediction?
    var isSuccess: Bool
}
protocol MCLPracticeViewModelDelegate: AnyObject {
    func viewModelProcessing(didDetect poses: [Pose]?,
                              in frame: CGImage)
    func viewModelProcessAlphabet(didDetect observations: [VNObservation]?)
}

class MCLPracticeViewModel: ObservableObject {
    struct Input {
        var didChangeCamera: AnyPublisher<Void, Never>
    }
    
    @Published var loaderCompleted: Bool = false
    @Published var startLoading: Bool = true
    @Published var error: Error?
    @Published var prediction: PredictionPracticeResult?

    let cameraManager = CaptureSessionManager.shared
    let alphabetPrediction = PassthroughSubject<String, Never>()
    weak var delegate: MCLPracticeViewModelDelegate?
    var classifierType: MCLDataType = .alphabet
    var continuePredicting: Bool = true
    var currentPrediction: ActionPrediction = ActionPrediction(action: .unknown, confidence: 100.0)
    
    private let context = CIContext()
    private let handPoseRequest: VNDetectHumanHandPoseRequest = {
        let request = VNDetectHumanHandPoseRequest()
        request.maximumHandCount = 2
        return request
    }()
    private lazy var alphabetRequest: VNCoreMLRequest = {
        do {
            let configuration = MLModelConfiguration()
            let model = try VNCoreMLModel(for: ASLClassifier.shared.model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in

            })

            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    private let predictionQueue = DispatchQueue(label: "ph.edu.mcl.FSLWizard.PredictionQueue")
    private let windowStride = 10
    private var predictionWindowSize: Int = 0
    private let classifier = PhrasesClassifierHand.shared
    private let alphabetClassifier = ASLClassifier.shared
    private let minimumConfidence = 0.6
    private let synthesizer = AVSpeechSynthesizer()

    private var cancelBag = Set<AnyCancellable>()
    
    init() {
        predictionWindowSize = classifier.calculatePredictionWindowSize()
    }
    
    func setupBinding(_ input: Input) {
        let didChangeCameraPublisher = input.didChangeCamera.share()
        
        didChangeCameraPublisher.sink { [weak self] _ in
            guard let self = self else {
                return
            }
            self.cameraManager.changeSource()
        }.store(in: &cancelBag)
        
        cameraManager.$error
            .receive(on: RunLoop.main)
            .map { $0 }
            .assign(to: &$error)

        // Set our frame prediction publisher
        cameraManager.$current
            .compactMap(imageFromFrame)
            .map(findPosesInFrame)
            .map(isolateLargestPose)
            .map(multiArrayFromPose)
            .scan([MLMultiArray?](), gatherWindow)
            .filter(gateWindow)
            .map(predictActionWithWindow)
            .receive(on: RunLoop.main)
            .assign(to: &$prediction)
        
        // Set our prediction result speech publisher
        $prediction
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] action in
                guard let self = self,
                      let action = action,
                      let _ = action.prediction else {
                    return
                }
                self.loaderCompleted = action.isSuccess
                self.startLoading = !action.isSuccess
            })
            .store(in: &cancelBag)
    }
    
    private func imageFromFrame(_ buffer: CMSampleBuffer?) -> CGImage? {
        guard let buffer = buffer,
              let imageBuffer = buffer.imageBuffer,
              continuePredicting else {
            return nil
        }

        // Create a Core Image context.
        let ciContext = CIContext(options: nil)

        // Create a Core Image image from the sample buffer.
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)

        // Generate a Core Graphics image from the Core Image image.
        guard let cgImage = ciContext.createCGImage(ciImage,
                                                    from: ciImage.extent)
        else {
            return nil
        }

        return cgImage
    }

    private func findPosesInFrame(_ frame: CGImage?) -> [Pose]? {
        guard let frame = frame else {
            return nil
        }

        // Create a request handler for the image.
        let visionRequestHandler = VNImageRequestHandler(cgImage: frame)

        // Use Vision to find human body poses in the frame.
        do { try visionRequestHandler.perform([alphabetRequest, handPoseRequest]) } catch {
            assertionFailure("Human Pose Request failed: \(error)")
        }

        guard let results = handPoseRequest.results else {
            return nil
        }
        let poses = Pose.fromObservations(results)
        
        // Send the frame and poses, if any, to the delegate on the main queue.
        DispatchQueue.main.async {
            self.delegate?.viewModelProcessing(didDetect: poses, in: frame)
        }
        
        if classifierType == .alphabet, !results.isEmpty {
            DispatchQueue.main.async {
                self.delegate?.viewModelProcessAlphabet(didDetect: self.alphabetRequest.results)
            }
        }
        return poses
    }

    /// Returns the largest pose by area.
    /// - Parameter poses: A `Pose` array optional.
    /// - Returns: The largest`Pose` when the array isn't empty; otherwise `nil`.
    /// - Tag: isolateLargestPose
    private func isolateLargestPose(_ poses: [Pose]?) -> Pose? {
        if classifierType == .alphabet {
            return nil
        }
        return poses?.max(by:) { pose1, pose2 in pose1.area < pose2.area }
    }

    /// Returns a pose's multiarray.
    /// - Parameter item: A pose from a human body-pose request.
    /// - Returns: The locations of the pose's landmarks in an `MLMultiArray`.
    /// - Tag: multiArrayFromPose
    private func multiArrayFromPose(_ item: Pose?) -> MLMultiArray? {
        if classifierType == .alphabet {
            return nil
        }
        return item?.multiArray
    }

    /// Collects a window of multiarrays by appending the most recent
    /// multiarray to the window.
    ///
    /// - Parameters:
    ///   - previousWindow: The previous window state from the last invocation.
    ///   - multiArray: The newest multiarray.
    /// - Returns: An`MLMultiArray` array.
    /// Before the methods appends the most recent body pose multiarray
    /// to the window, it removes the oldest multiarray elements
    /// if the previous window's count is the target size.
    /// - Tag: gatherWindow
    private func gatherWindow(previousWindow: [MLMultiArray?],
                      multiArray: MLMultiArray?) -> [MLMultiArray?] {
        if classifierType == .alphabet {
            return [nil]
        }
        var currentWindow = previousWindow

        // If the previous window size is the target size, it
        // means sendWindowWhenReady() just published an array window.
        if previousWindow.count == predictionWindowSize {
            // Advance the sliding array window by stride elements.
            currentWindow.removeFirst(windowStride)
        }

        // Add the newest multiarray to the window.
        currentWindow.append(multiArray)

        // Publish the array window to the next subscriber.
        // The currentWindow becomes this method's next previousWindow when
        // it receives the next multiarray from the upstream publisher.
        return currentWindow
    }

    /// Returns a Boolean that indicates whether the window contains the
    /// number of multiarray elements the action classifier needs to make a
    /// prediction.
    /// - Parameter currentWindow: An array of multiarray optionals.
    /// - Returns: `true` if `currentWindow` contains `predictionWindowSize`
    /// elements; otherwise `false`.
    /// - Tag: gateWindow
    private func gateWindow(_ currentWindow: [MLMultiArray?]) -> Bool {
        return currentWindow.count == predictionWindowSize
    }

    /// Makes a prediction from the multiarray window.
    /// - Parameter currentWindow: An`MLMultiArray?` array.
    /// - Returns: An `ActionPrediction`.
    /// - Tag: predictActionWithWindow
    private func predictActionWithWindow(_ currentWindow: [MLMultiArray?]) -> PredictionPracticeResult? {
        var poseCount = 0

        // Fill the nil elements with an empty pose array.
        let filledWindow: [MLMultiArray] = currentWindow.map { multiArray in
            if let multiArray = multiArray {
                poseCount += 1
                return multiArray
            } else {
                return Pose.emptyPoseMultiArray
            }
        }

        // Only use windows with at least 60% real data to make a prediction
        // with the action classifier.
        let minimum = predictionWindowSize * 60 / 100
        guard poseCount >= minimum else {
            return PredictionPracticeResult(prediction: nil, isSuccess: false)
        }

        // Merge the array window of multiarrays into one multiarray.
        let mergedWindow = MLMultiArray(concatenating: filledWindow,
                                        axis: 0,
                                        dataType: .float32)

        // Make a genuine prediction with the action classifier.
        let prediction = classifier.predictActionFromWindow(mergedWindow)

        // Return the model's prediction if the confidence is high enough.
        // Otherwise, return a "Low Confidence" prediction.
        return checkConfidence(prediction)
    }

    /// Sends an action prediction to the delegate on the main thread.
    /// - Parameter actionPrediction: The action classifier's prediction.
    /// - Tag: checkConfidence
    private func checkConfidence(_ actionPrediction: ActionPrediction) -> PredictionPracticeResult? {
        if currentPrediction.action == actionPrediction.action {
            return PredictionPracticeResult(prediction: actionPrediction, isSuccess: true)
        }
        
        return PredictionPracticeResult(prediction: nil, isSuccess: false)
    }
    
    // MARK: AVFoundation
    private func performSpeech(_ speech: String) {
        let speech = AVSpeechUtterance(string: speech)
        speech.voice = AVSpeechSynthesisVoice(language: "en-GB")
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        synthesizer.speak(speech)
    }
}
