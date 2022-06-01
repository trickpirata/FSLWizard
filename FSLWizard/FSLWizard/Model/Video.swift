//
//  Video.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 3/4/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import Foundation

struct Video: Codable, Identifiable {
    let id = UUID().uuidString
    let title: String
    let video: String
}
