//
//  MCLAboutContentView.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 6/1/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import SwiftUI
import FSLWizardUI

struct MCLAboutContentView: View {
    @Environment(\.defaultStyle) private var style
    @EnvironmentObject private var router: MCLMainCoordinator.Router
    
    @State private var scale = false
    var body: some View {
        ZStack {
            style.color.secondaryCustomBackground.suColor.ignoresSafeArea()
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height:100)
                    Image("mcl-logo")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: Alignment.center)
                    
                    VStack {
                        Text("Fritz Victor Legayada")
                        Text("Jarod Dauberman")
                        Text("Trick Gorospe")
                        Text("Jennifer Coloma")
                        Spacer()
                            .frame(height: 50)
                        VStack {
                            Text("American Sign Language Wizard is a project to demonstrate computer vision and machine learning capabilities in a mobile application to help educate and spread awareness about sign language.").font(.caption).padding()
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("Credits").font(.caption)
                                Spacer()
                            }.padding(.leading)
                            VStack {
                                Text("Word-level Deep Sign Language Recognition from Video: A New Large-scale Dataset and Methods Comparison\nhttps://github.com/dxli94/WLASL").font(.caption).padding(.leading)
                            }
                        }
                    }
                        
                    Spacer()
                }.onAppear(perform: {
                    
                })
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct MCLAboutContentView_Previews: PreviewProvider {
    static var previews: some View {
        MCLAboutContentView()
    }
}
#endif
