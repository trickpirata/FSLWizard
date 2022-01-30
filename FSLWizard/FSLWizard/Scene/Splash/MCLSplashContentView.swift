//
//  MCLSplashContentView.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 1/30/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import SwiftUI
import FSLWizardUI
import Stinsen

struct MCLSplashContentView: View {
    @Environment(\.defaultStyle) private var style
    @EnvironmentObject private var router: MCLMainCoordinator.Router
    
    @State private var scale = false
    var body: some View {
        ZStack {
            style.color.secondaryCustomBackground.suColor.ignoresSafeArea()
            VStack {
                Spacer()
                Image("mcl-logo")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: Alignment.center)
                    .scaleEffect(scale ? 1 : 2)
                    .animation(.linear(duration: 1.5), value: scale)
                Spacer()
            }.onAppear(perform: {
                scale.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    router.root(\.camera)
                }
            })
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct MCLSplashContentView_Previews: PreviewProvider {
    static var previews: some View {
        MCLSplashContentView()
    }
}
#endif
