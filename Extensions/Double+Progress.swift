//
//  Double+Progress.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 17.02.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import Foundation

extension Double {
    
    public func progress(between startDate: Date?, and targetDate: Date?) -> Double {
        guard let startDate = startDate, let targetDate = targetDate else {
            return 0
        }
        
        let progress = Double((Date().timeIntervalSinceNow - startDate.timeIntervalSinceNow) / (targetDate.timeIntervalSinceNow - startDate.timeIntervalSinceNow))

        return progress.isNaN || progress < 0 ? 0 : (progress > 1 ? 1 : progress)
    }
    
    public func progress(between number: Double?, and targetNumber: Double?) -> Double {
        guard let number = number, let targetNumber = targetNumber else { return 0 }
        
        let progress = number/targetNumber

        return progress.isNaN || progress < 0 ? 0 : (progress > 1 ? 1 : progress)
    }
    
}
