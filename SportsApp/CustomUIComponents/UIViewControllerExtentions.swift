//
//  UIViewControllerExtentions.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 09.05.2022.
//

import Foundation
import UIKit

extension UIViewController {
    func makeKeyboardDismissable() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func dismissKeyboard(_ sender: UIGestureRecognizer) {
        view.endEditing(true)
    }
    
    func displayErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func configureKeyboardInsets(bottomScrollConstraint: NSLayoutConstraint) {
        let keyboardWillShowAction = NotificationAction { [weak bottomScrollConstraint, weak self] notification in
            if let keyboardSize =
               (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                bottomScrollConstraint?.constant = -keyboardSize.height
                self?.view.layoutIfNeeded()
            }
        }
        
        let keyboardWillHideAction = NotificationAction { [weak bottomScrollConstraint, weak self] _ in
            bottomScrollConstraint?.constant = 0
            self?.view.layoutIfNeeded()
        }
        
        NotificationCenter.default.addObserver(
            keyboardWillShowAction,
            selector: #selector(keyboardWillShowAction.action(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            keyboardWillHideAction,
            selector: #selector(keyboardWillHideAction.action(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            keyboardWillShowAction,
            selector: #selector(keyboardWillShowAction.action(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    private class NotificationAction {
        private static var actions = [NotificationAction]()
        private let actionClosure: (NSNotification) -> ()
        
        init(action: @escaping (NSNotification) -> ()) {
            actionClosure = action
            Self.actions.append(self)
        }
        
        @objc func action(notification: NSNotification) {
            actionClosure(notification)
        }
    }
    
}
