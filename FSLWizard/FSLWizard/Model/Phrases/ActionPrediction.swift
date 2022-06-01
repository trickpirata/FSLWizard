//
//  ActionPrediction.swift
//  RemoteCamera
//
//  Created by Trick Gorospe on 6/2/21.
//  Copyright © 2021 Mirror Vision. All rights reserved.
//

/// Bundles an action label with a confidence value.
/// - Tag: ActionPrediction
struct ActionPrediction {
    /// The action prediction enum as defined in the classifier
    let action: PhrasesClassifierHand.Action

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

    init(action: PhrasesClassifierHand.Action, confidence: Double) {
        self.action = action
        self.label = action.rawValue
        self.confidence = confidence
    }
}

extension ActionPrediction: Equatable {
    static func == (lhs: ActionPrediction, rhs: ActionPrediction) -> Bool {
        return lhs.action == rhs.action
    }
}
