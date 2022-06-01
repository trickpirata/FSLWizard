//
//  MCLCheckView.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 6/1/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//
// Based on: https://github.com/HuangRunHua/EnterButtonAnimation/blob/master/EnterButtonAnimation/CheckView.swift

import SwiftUI
import FSLWizardUI

struct MCLCheckView: View {
    @State var checkViewAppear = false
    
    @Environment(\.defaultStyle) private var style
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width: CGFloat = min(geometry.size.width, geometry.size.height)
                let height = geometry.size.height
                
                path.addLines([
                    .init(x: width/2 - 10, y: height/2 - 10),
                    .init(x: width/2, y: height/2),
                    .init(x: width/2 + 20, y: height/2 - 20),
                ])
            }
            .trim(from: 0, to: checkViewAppear ? 1 : 0)
            .stroke(style: StrokeStyle(lineWidth: 2.0, lineCap: .round))
            .animation(.easeIn(duration: 1.5), value: checkViewAppear)
            .frame(width: 50, height: 50)
            .aspectRatio(1, contentMode: .fit)
            .onAppear() {
                self.checkViewAppear.toggle()
            }
        }.frame(width: 50, height: 50)
    }
}

#if DEBUG
struct MCLCheckView_Previews: PreviewProvider {
    static var previews: some View {
        MCLCheckView()
    }
}
#endif
