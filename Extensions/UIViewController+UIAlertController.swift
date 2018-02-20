//
//  UIViewController+UIAlertController.swift
//  Dream
//
//  Created by Богдан Чайковский on 20.02.2018.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

extension UIViewController {
    
    open func presentAlert(title: String?, message: String?, actions: (title: String, action: (() -> Swift.Void)?) ...) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actions.forEach { (title, action) in
            alert.addAction(
                UIAlertAction(
                    title  : title,
                    style  : .default,
                    handler: action != nil ? { _ in action?() } : nil
                )
            )
        }
        
        present(alert, animated: true)
    }
    
    open func presentAlert(title: String?, message: String?, action: (() -> Swift.Void)? = nil) {
        
        presentAlert(title: title, message: message, actions: (
            NSLocalizedString("Ok", comment: "Confirm alert"),
            action
        ))
    }
    
    open func presentAlert(title: String?, message: String?, yesAction: @escaping (() -> Swift.Void), noAction: (() -> Swift.Void)? = nil) {
        
        presentAlert(
            title  : title,
            message: message,
            actions: (
                NSLocalizedString("Yes", comment: "Yes button in alert"),
                yesAction
            ), (
                NSLocalizedString("No" , comment: "No button in alert" ),
                noAction
            )
        )
    }
    
}
