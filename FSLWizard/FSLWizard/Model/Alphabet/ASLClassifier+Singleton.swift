//
//  ASLClassifier+Singleton.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 3/4/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

import CoreML

extension ASLClassifier {
    /// Creates a shared Exercise Classifier instance for the app at launch.
    static let shared: ASLClassifier = {
        // Use a default model configuration.
        let defaultConfig = MLModelConfiguration()

        guard let classifier = try? ASLClassifier(configuration: defaultConfig) else {
            // The app requires the action classifier to function.
            fatalError("ASLClassifier failed to initialize.")
        }

        return classifier
    }()
}
