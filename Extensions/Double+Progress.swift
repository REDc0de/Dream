//
//  Double+Progress.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 17.02.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

extension Double {
    
    public func progress(between startDate: Date?, and targetDate: Date?) -> Double {
        
        guard let startDate = startDate, let targetDate = targetDate else { return 0 }
        
        var progress = Double((Date().timeIntervalSinceNow - startDate.timeIntervalSinceNow) / (targetDate.timeIntervalSinceNow - startDate.timeIntervalSinceNow))
        
        if progress < 0 { progress = 0}
        if progress > 1 { progress = 1}
        
        return progress
    }
    
    public func progress(between number: Double?, and targetNumber: Double?) -> Double {
        
        guard let number = number, let targetNumber = targetNumber else { return 0 }
        
        var progress = number/targetNumber
        
        if progress < 0 { progress = 0}
        if progress > 1 { progress = 1}
        
        return progress
    }
    
}
