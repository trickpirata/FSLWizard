//
//  MCLRoundedCorners.swift
//  GeneroUI
//
//  Created by Trick Gorospe on 7/9/21.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import SwiftUI

public struct MCLRoundedCorners: View {
    private let color: Color
    private let tl: CGFloat
    private let tr: CGFloat
    private let bl: CGFloat
    private let br: CGFloat
    
    public var body: some View {
        GeometryReader { geometry in
            Path { path in
                
                let w = geometry.size.width
                let h = geometry.size.height
                
                // Make sure we do not exceed the size of the rectangle
                let tr = min(min(self.tr, h/2), w/2)
                let tl = min(min(self.tl, h/2), w/2)
                let bl = min(min(self.bl, h/2), w/2)
                let br = min(min(self.br, h/2), w/2)
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
            }
            .fill(self.color)
        }
    }
    
    public init(color: Color, topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        self.color = color
        self.tl = topLeft
        self.tr = topRight
        self.bl = bottomLeft
        self.br = bottomRight
    }
}

#if DEBUG
struct MCLRoundedCorners_Previews: PreviewProvider {
    static var previews: some View {
        MCLRoundedCorners(color: Color.gray, topLeft: 30, topRight: 30, bottomLeft: 0, bottomRight: 0)
    }
}
#endif
