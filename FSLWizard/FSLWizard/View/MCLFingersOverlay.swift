//
//  MCLFingersOverlay.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 2/2/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import SwiftUI

struct MCLFingersConnectionOverlay: Shape {
    let points: [Pose.Connection]
    private let pointsPath = UIBezierPath()
    
    init(with points: [Pose.Connection]) {
        self.points = points
    }
    
//    func path(in rect: CGRect) -> Path {
//        for point in points {
//            pointsPath.move(to: point)
//            pointsPath.addArc(withCenter: point, radius: 5, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
//        }
//
//        return Path(pointsPath.cgPath)
//    }
    
    func path(in rect: CGRect) -> Path {
        for point in points {
            pointsPath.move(to: point.point1)
            pointsPath.addLine(to: point.point2)
//            pointsPath.stroke()
//            pointsPath.addClip()
        }
        
        return Path(pointsPath.cgPath)
    }
}

struct MCLFingersLandmarksOverlay: Shape {
    let points: [Pose.Landmark]
    private let pointsPath = UIBezierPath()
    
    init(with points: [Pose.Landmark]) {
        self.points = points
        print(points)
    }
    
    func path(in rect: CGRect) -> Path {
        for point in points {
            pointsPath.move(to: point.location)
            pointsPath.addArc(withCenter: point.location, radius: 100, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        }

        return Path(pointsPath.cgPath)
    }
}
