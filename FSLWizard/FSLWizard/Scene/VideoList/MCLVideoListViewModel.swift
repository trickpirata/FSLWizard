//
//  MCLVideoListViewModel.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 3/4/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import Foundation
import Combine
import AVFoundation
import SwiftUI

class MCLVideoListViewModel: ObservableObject {
    
    @Published var videoList: [Video]
    
    init() {
        videoList = []
        setupData()
        setupBinding()
    }
    
    func createThumbnail(for name: String) -> Image? {
        do {
            guard let url = Bundle.main.url(forResource: name, withExtension: "mp4") else {
                return nil
            }
            
            let asset = AVURLAsset(url: url, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return Image(uiImage: thumbnail)
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }

    private func setupData() {
        videoList = loadJson(filename: "videolist")
    }
    
    private func setupBinding() {
        
    }
    
    private func loadJson(filename fileName: String) -> [Video] {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Video].self, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return []
    }
}
