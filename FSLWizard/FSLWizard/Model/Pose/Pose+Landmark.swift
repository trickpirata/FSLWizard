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
 A `Landmark` is the name and location of a point on a human body, including:
 - Left shoulder
 - Right eye
 - Nose
 */

import UIKit
import Vision

@available(iOS 14.0, *)
extension Pose {
    typealias JointName = VNHumanHandPoseObservation.JointName

    /// The name and location of a point of interest on a human body.
    ///
    /// Each landmark defines its location in an image and the name of the body
    /// joint it represents, such as nose, left eye, right knee, and so on.
    struct Landmark {
        /// The minimum `VNRecognizedPoint` confidence for a valid `Landmark`.
        static let threshold: Float = 0.2

        /// The drawing radius of a landmark.
        static let radius: CGFloat = 14.0

        /// The name of the landmark.
        ///
        /// For example, "left shoulder", "right knee", "nose", and so on.
        let name: JointName

        /// The location of the landmark in normalized coordinates.
        ///
        /// When calling `drawToContext()`, use a transform to apply a scale
        /// that's appropriate for the graphics context.
        let location: CGPoint

        /// Creates a landmark from a point.
        /// - Parameter point: A point in a human body pose observation.
        init?(_ point: VNRecognizedPoint) {
            // Only create a landmark from a point that satisfies the minimum
            // confidence.
            guard point.confidence >= Pose.Landmark.threshold else {
                return nil
            }

            name = JointName(rawValue: point.identifier)
            location = point.location
        }

        /// Draws a circle at the landmark's location after transformation.
        /// - Parameters:
        ///   - context: A context the method uses to draw the landmark.
        ///   - transform: A transform that modifies the point locations.
        func drawToContext(_ context: CGContext,
                           applying transform: CGAffineTransform? = nil,
                           at scale: CGFloat = 1.0) {
            context.setFillColor(UIColor.white.cgColor)
            context.setStrokeColor(UIColor.darkGray.cgColor)

            // Define the rectangle's origin by applying the transform to the
            // landmark's normalized location.
            let origin = location.applying(transform ?? .identity)

            // Define the size of the circle's rectangle with the radius.
            let radius = Landmark.radius * scale
            let diameter = radius * 2
            let rectangle = CGRect(x: origin.x - radius,
                                   y: origin.y - radius,
                                   width: diameter,
                                   height: diameter)

            context.addEllipse(in: rectangle)
            context.drawPath(using: CGPathDrawingMode.fillStroke)
        }
    }
}
