//
//  String+.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 3/4/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import Foundation

extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
