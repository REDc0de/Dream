//
//  DRTimerCircleProgressView.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 15.03.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DRTimerCircleProgressView: UICircleProgressView {
    
    // MARK: - Internal properties
    
    private var timer: Timer?
    private var startDate: Date?
    private var targetDate: Date?
    private var timeProgress: Double {
        get{
            return Double().progress(between: self.startDate, and: self.targetDate)
        }
    }
    
    // MARK: - Methods
    
    public func scheduleTimer(startDate: Date, targetDate: Date) {
        self.startDate = startDate
        self.targetDate = targetDate
        
        self.updateValue()
        
        let timeInterval = targetDate.timeIntervalSince(startDate)/360 // time interval for 1 degrees filling
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.updateValue), userInfo: nil, repeats: true)
    }
    
    public func invalidateTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: - Actions
    
    @objc private func updateValue() {
        self.value = Float(self.timeProgress)

        if self.timeProgress == 1 {
            invalidateTimer()
        }
    }
    
}
