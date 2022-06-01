/*
 Copyright © 2021 Apple Inc.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
 associated documentation files (the "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
 LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
 EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
 THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 Abstract:
 A `Pose` is a collection of "landmarks" and connections between select landmarks.
 Each `Pose` can draw itself as a wireframe to a Core Graphics context.
 */

import UIKit
import Vision

@available(iOS 14.0, *)
typealias Observation = VNHumanHandPoseObservation
/// Stores the landmarks and connections of a human body pose and draws them as
/// a wireframe.
/// - Tag: Pose
@available(iOS 14.0, *)
struct Pose {

    /// A list of lines between landmarks for drawing a wireframe.
    var connections: [Connection]!

    /// The names and locations of the significant points on a human body.
    let landmarks: [Landmark]

    /// The locations of the pose's landmarks as a multiarray.
    /// - Tag: multiArray
    let multiArray: MLMultiArray?

    /// A rough approximation of the landmarks' area.
    let area: CGFloat

    /// Creates a `Pose` for each human body pose observation in the array.
    /// - Parameter observations: An array of human body pose observations.
    /// - Returns: A `Pose` array.

    static func fromObservations(_ observations: [Observation]?) -> [Pose]? {
        // Convert each observations to a `Pose`.
        observations?.compactMap { observation in Pose(observation) }
    }

    /// Creates a wireframe from a human pose observation.
    /// - Parameter observation: A human body pose observation.
    init?(_ observation: Observation) {
        // Create a landmark for each joint in the observation.
        landmarks = observation.availableJointNames.compactMap { jointName in
//            guard jointName != JointName. else {
//                return nil
//            }

            guard let point = try? observation.recognizedPoint(jointName) else {
                return nil
            }

            return Landmark(point)
        }

        guard !landmarks.isEmpty else { return nil }

        //
        area = Pose.areaEstimateOfLandmarks(landmarks)

        // Save the multiarray from the observation.
        multiArray = try? observation.keypointsMultiArray()

        // Build a list of connections from the pose's landmarks.
        buildConnections()
    }

    /// Draws all the valid connections and landmarks of the wireframe.
    /// - Parameters:
    ///   - context: A context the method uses to draw the wireframe.
    ///   - transform: A transform that modifies the point locations.
    /// - Tag: drawWireframeToContext
    func drawWireframeToContext(_ context: CGContext,
                                applying transform: CGAffineTransform? = nil) {
        let scale = drawingScale

        // Draw the connection lines first.
        connections.forEach { line in
            line.drawToContext(context, applying: transform, at: scale)
        }

        // Draw the landmarks on top of the lines' endpoints.
        landmarks.forEach { landmark in
            landmark.drawToContext(context,
                                   applying: transform,
                                   at: scale)
        }
    }

    /// Adjusts the landmarks radius and connection thickness when the pose draws
    /// itself as a wireframe.
    private var drawingScale: CGFloat {
        /// The typical size of a dominant pose.
        ///
        /// The sample's author empirically derived this value.
        let typicalLargePoseArea: CGFloat = 0.35

        /// The largest scale is 100%.
        let max: CGFloat = 1.0

        /// The smallest scale is 60%.
        let min: CGFloat = 0.6

        /// The area's ratio relative to the typically large pose area.
        let ratio = area / typicalLargePoseArea

        let scale = ratio >= max ? max : (ratio * (max - min)) + min
        return scale
    }
}

// MARK: - Helper methods

@available(iOS 14.0, *)
extension Pose {
    /// Creates an array of connections from the available landmarks.
    mutating func buildConnections() {
        // Only build the connections once.
        guard connections == nil else {
            return
        }

        connections = [Connection]()

        // Get the joint name for each landmark.
        let joints = landmarks.map { $0.name }

        // Get the location for each landmark.
        let locations = landmarks.map { $0.location }

        // Create a lookup dictionary of landmark locations.
        let zippedPairs = zip(joints, locations)
        let jointLocations = Dictionary(uniqueKeysWithValues: zippedPairs)

        // Add a connection if both of its endpoints have valid landmarks.
        for jointPair in Pose.jointPairs {
            guard let one = jointLocations[jointPair.joint1] else { continue }
            guard let two = jointLocations[jointPair.joint2] else { continue }

            connections.append(Connection(one, two))
        }
    }

    /// Returns a rough estimate of the landmarks' collective area.
    /// - Parameter landmarks: A `Landmark` array.
    /// - Returns: A `CGFloat` that is greater than or equal to `0.0`.
    static func areaEstimateOfLandmarks(_ landmarks: [Landmark]) -> CGFloat {
        let xCoordinates = landmarks.map { $0.location.x }
        let yCoordinates = landmarks.map { $0.location.y }

        guard let minX = xCoordinates.min() else { return 0.0 }
        guard let maxX = xCoordinates.max() else { return 0.0 }

        guard let minY = yCoordinates.min() else { return 0.0 }
        guard let maxY = yCoordinates.max() else { return 0.0 }

        let deltaX = maxX - minX
        let deltaY = maxY - minY

        return deltaX * deltaY
    }
}
