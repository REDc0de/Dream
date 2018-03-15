//
//  UIView+CALayer.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 12.03.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable
    var borderWidth: Float {
        get {
            return Float(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var cornerRadius: Float {
        get {
            return Float(self.layer.cornerRadius)
        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            guard let color = self.layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
            self.setNeedsDisplay()
        }
    }
    
}
