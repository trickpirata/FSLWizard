//
//  MCLLoadingView.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 6/1/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//
// Based on: https://github.com/HuangRunHua/EnterButtonAnimation/blob/master/EnterButtonAnimation/ButtonAnimationView.swift

import SwiftUI
import Combine
import FSLWizardUI

struct MCLLoadingView: View {
    @Binding var startLoading: Bool
    @State private var loading = false
    @State private var fullcircle = false
    @Binding var completed: Bool
    
    @Environment(\.defaultStyle) private var style
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .trim(from: 0, to: self.fullcircle ? 0.95 : 1)
                .stroke(lineWidth: 5)
                .frame(width: self.startLoading ? 60 : 0, height: 60)
                .foregroundColor(self.startLoading ? .white : Color(red: 230/255, green: 230/255, blue: 230/255))
                .background(self.startLoading ? .clear : style.color.buttonColor1.suColor)
            
                .cornerRadius(30)
                .rotationEffect(Angle(degrees: self.loading ? 0 : -1440))
                .onAppear {
                    withAnimation(.default) {
                        self.startLoading = true
                        self.fullcircle = true
                        self.startProcessing()
                    }
                }
            
            if completed {
                MCLCheckView()
                    .offset(x: -5, y: 9)
                    .foregroundColor(.green)
            }
        }
    }
    
    func startProcessing() {
        withAnimation(Animation.linear(duration: 5).repeatForever(autoreverses: false)) {
            self.loading = true
        }
    }
    
    func endProcessing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.completed = true
            self.fullcircle = false
        }
    }
}

#if DEBUG
struct MCLLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        MCLLoadingView(startLoading: .constant(true), completed: .constant(true))
    }
}
#endif
