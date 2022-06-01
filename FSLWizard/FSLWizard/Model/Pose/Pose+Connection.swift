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
 A `Connection` defines the line between two landmarks.
 The only real purpose for a connection is to draw that line with a gradient.
 */

import UIKit

@available(iOS 14.0, *)
// swiftlint:disable force_unwrapping
extension Pose {
    /// Represents a line between two landmarks.
    struct Connection: Equatable {
        static let width: CGFloat = 12.0

        /// The gradient colors the connection uses to draw its line.
        static let colors = [UIColor.systemGreen.cgColor,
                             UIColor.systemYellow.cgColor,
                             UIColor.systemOrange.cgColor,
                             UIColor.systemRed.cgColor,
                             UIColor.systemPurple.cgColor,
                             UIColor.systemBlue.cgColor] as CFArray

        static let gradientColorSpace = CGColorSpace(name: CGColorSpace.sRGB)

        static let gradient = CGGradient(colorsSpace: gradientColorSpace,
                                         colors: colors,
                                         locations: [0, 0.2, 0.33, 0.5, 0.66, 0.8])

        /// The connection's first endpoint.
        let point1: CGPoint

        /// The connection's second endpoint.
        let point2: CGPoint

        /// Creates a connection from two points.
        ///
        /// The order of the points isn't important.
        /// - Parameters:
        ///   - one: The location for one end of the connection.
        ///   - two: The location for the other end of the connection.
        init(_ one: CGPoint, _ two: CGPoint) { point1 = one; point2 = two }

        /// Draws a line from the connection's first endpoint to its other
        /// endpoint.
        /// - Parameters:
        ///   - context: The Core Graphics context to draw to.
        ///   - transform: An affine transform that scales and translate each
        ///   endpoint.
        ///   - scale: The scale that adjusts the line's thickness
        func drawToContext(_ context: CGContext,
                           applying transform: CGAffineTransform? = nil,
                           at scale: CGFloat = 1.0) {
            let start = point1.applying(transform ?? .identity)
            let end = point2.applying(transform ?? .identity)

            // Store the current graphics state.
            context.saveGState()

            // Restore the graphics state after the method finishes.
            defer { context.restoreGState() }

            // Set the line's thickness.
            context.setLineWidth(Connection.width * scale)

            // Draw the line.
            context.move(to: start)
            context.addLine(to: end)
            context.replacePathWithStrokedPath()
            context.clip()

            context.drawLinearGradient(Connection.gradient!,
                                       start: start,
                                       end: end,
                                       options: .drawsAfterEndLocation)
        }
    }
}

@available(iOS 14.0, *)
extension Pose {
    /// A series of joint pairs that define the wireframe lines of a pose.
    static let jointPairs: [(joint1: JointName, joint2: JointName)] = [
        // Index connections
        (.wrist, .indexMCP),
        (.indexMCP, .indexPIP),
        (.indexPIP, .indexDIP),
        (.indexDIP, .indexTip),
        
        // Little finger connections
        (.wrist, .littleMCP),
        (.littleMCP, .littlePIP),
        (.littlePIP, .littleDIP),
        (.littleDIP, .littleTip),
        
        // Middle finger connections
        (.wrist, .middleMCP),
        (.middleMCP, .middlePIP),
        (.middlePIP, .middleDIP),
        (.middleDIP, .middleTip),
        
        // Ring finger connections
        (.wrist, .ringMCP),
        (.ringMCP, .ringPIP),
        (.ringPIP, .ringDIP),
        (.ringDIP, .ringTip),
        
        // Thumb finger connections
        (.wrist, .thumbCMC),
        (.thumbCMC, .thumbMP),
        (.thumbMP, .thumbIP),
        (.thumbIP, .thumbTip),
    ]
}
