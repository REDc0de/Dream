//
//  DRCircleProgressView.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 05.04.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DRCircleProgressView: UICircleProgressView {
    
    // MARK: Internal properties
    
    fileprivate var symbolLabel = UILabel()

    // MARK: Customization
    
    @IBInspectable
    open var symbol: String? {
        get {

            return symbolLabel.text
        }
        set {
            addLabel()
            symbolLabel.text = newValue
        }
    }
    
    func addLabel() {
        self.addSubview(symbolLabel)
        symbolLabel.textColor = UIColor.red
    }
    
}
