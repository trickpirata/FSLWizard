//
//  ASLClassifier+Actions.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 3/4/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

extension ASLClassifier {
    // Represents the app's knowledge of the Classifier model's labels.
    enum Action: String, CaseIterable {
        case A
        case B
        case C
        case D
        case E
        case F
        case G
        case H
        case I
        case J
        case K
        case L
        case M
        case N
        case O
        case P
        case Q
        case R
        case S
        case T
        case U
        case V
        case W
        case X
        case Y
        case Z
        
        case unknown
        case lowConfidence

        /// Creates a label from a string.
        /// - Parameter label: The name of an action class.
        init(_ string: String) {
            guard let label = Action(rawValue: string) else {
                let typeName = String(reflecting: Action.self)
                fatalError("Add the `\(string)` label to the `\(typeName)` type.")
            }

            self = label
        }
    }
}
