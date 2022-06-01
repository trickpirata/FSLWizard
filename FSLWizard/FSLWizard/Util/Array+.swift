//
//  Array+.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 3/3/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import Foundation
import Combine

extension Array where Element == AnyCancellable {
    public func store(in set: inout Set<AnyCancellable>) {
        forEach { $0.store(in: &set) }
    }
}
