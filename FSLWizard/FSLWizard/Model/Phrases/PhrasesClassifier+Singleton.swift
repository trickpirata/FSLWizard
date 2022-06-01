//
//  PhrasesClassifier+Singleton.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 3/1/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import CoreML

extension PhrasesClassifierHand {
    /// Creates a shared Exercise Classifier instance for the app at launch.
    static let shared: PhrasesClassifierHand = {
        // Use a default model configuration.
        let defaultConfig = MLModelConfiguration()

        guard let classifier = try? PhrasesClassifierHand(configuration: defaultConfig) else {
            // The app requires the action classifier to function.
            fatalError("PhrasesClassifier failed to initialize.")
        }

        return classifier
    }()
}
