//
//  PhrasesClassifier+Actions.swift
//  FSLWizard
//
//  Created by Trick Gorospe on 3/1/22.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//

extension PhrasesClassifierHand {
    /// Represents the app's knowledge of the Classifier model's labels.
    enum Action: String, CaseIterable {
        case accident
        case africa
        case all
        case apple
        case basketball
        case bed
        case before
        case bird
        case birthday
        case black
        case blue
        case book
        case bowling
        case brown
        case but
        case can
        case candy
        case chair
        case change
        case cheat
        case city
        case clothes
        case color
        case computer
        case cook
        case cool
        case corn
        case cousin
        case cow
        case dance
        case dark
        case deaf
        case decide
        case doctor
        case dog
        case drink
        case eat
        case enjoy
        case family
        case fine
        case finish
        case fish
        case forget
        case full
        case give
        case go
        case graduate
        case hat
        case hearing
        case help
        case hot
        case how
        case jacket
        case kiss
        case language
        case last
        case later
        case letter
        case like
        case man
        case many
        case medicine
        case meet
        case mother
        case need
        case no
        case now
        case orange
        case paint
        case paper
        case pink
        case pizza
        case play
        case pull
        case purple
        case right
        case same
        case school
        case secretary
        case shirt
        case short
        case son
        case study
        case table
        case tall
        case tell
        case thanksgiving
        case thin
        case thursday
        case time
        case visit
        case wait
        case walk
        case want
        case water
        case what
        case white
        case who
        case wife
        case woman
        case work
        case wrong
        case year
        case yes
        
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
