//
//  KeyboardResponder.swift
//  GeneroUI
//
//  Created by Trick Gorospe on 10/29/21.
//  Copyright © 2022 Malayan Colleges Laguna. All rights reserved.
//
//https://stackoverflow.com/questions/57739966/how-to-make-the-bottom-button-follow-the-keyboard-display-in-swiftui

import SwiftUI
import UIKit
import Foundation
import Combine

public class MCLKeyboardResponder: ObservableObject {
    let willset = PassthroughSubject<CGFloat, Never>()
    private var _center: NotificationCenter
    @Published public var currentHeight: CGFloat = 0
    var keyboardDuration: TimeInterval = 0

    public init(center: NotificationCenter = .default) {
        _center = center
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        _center.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            guard let duration:TimeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
            keyboardDuration = duration

            withAnimation(.easeInOut(duration: duration)) {
                self.currentHeight = keyboardSize.height
            }

        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        guard let duration:TimeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        withAnimation(.easeInOut(duration: duration)) {
            currentHeight = 0
        }
    }
}
