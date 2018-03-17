//
//  DRTimerLabel.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 15.03.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DRTimerLabel: UILabel {
    
    // MARK: - Internal properties
    
    private var timer: Timer?
    private var targetDate: Date?
    
    // MARK: - Methods
    
    public func scheduleTimer(targetDate: Date) {
        self.targetDate = targetDate
        
        self.updateText()
        
        let timeInterval = targetDate.timeIntervalSince(Date())/360 // time interval for 1 degrees filling
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.updateText), userInfo: nil, repeats: true)
    }
    
    public func invalidateTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    // MARK: - Actions
    
    @objc private func updateText() {
        guard let targetDate = self.targetDate else {
            return
        }
        
        DispatchQueue.main.async {
            self.text = Date().offset(to: targetDate)
        }
        
        if Date().timeIntervalSinceNow > targetDate.timeIntervalSinceNow {
            invalidateTimer()
        }
    }
    
}
