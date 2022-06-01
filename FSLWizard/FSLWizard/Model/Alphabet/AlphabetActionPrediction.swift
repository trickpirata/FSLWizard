//
//  AlphabetActionPrediction.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 3/4/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import Foundation

struct AlphabetActionPrediction {
    /// The action prediction enum as defined in the classifier
    let action: ASLClassifier.Action

    /// The name of the action the Exercise Classifier predicted.
    let label: String

    /// The Exercise Classifier's confidence in its prediction.
    let confidence: Double!

    /// A string that represents the confidence as percentage if applicable;
    /// otherwise `nil`.
    var confidenceString: String? {
        guard let confidence = confidence else {
            return nil
        }

        // Convert the confidence to a percentage based string.
        let percent = confidence * 100
        let formatString = percent >= 99.5 ? "%2.0f %%" : "%2.1f %%"
        return String(format: formatString, percent)
    }

    init(action: ASLClassifier.Action, confidence: Double) {
        self.action = action
        self.label = action.rawValue
        self.confidence = confidence
    }
}

extension AlphabetActionPrediction: Equatable {
    static func == (lhs: AlphabetActionPrediction, rhs: AlphabetActionPrediction) -> Bool {
        return lhs.action == rhs.action
    }
}
