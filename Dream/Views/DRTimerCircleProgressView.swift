//
//  DRTimerCircleProgressView.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 15.03.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DRTimerCircleProgressView: UICircleProgressView {

    // MARK: - Properties
    
    public var startDate: Date? {
        didSet{
            self.setTimer()
        }
    }
    
    public var targetDate: Date? {
        didSet{
            self.setTimer()
        }
    }
    
    // MARK: - Internal properties
    
    private var timer: Timer?
    
    private var timeProgress: Double {
        get{
            return Double().progress(between: self.startDate, and: self.targetDate)
        }
    }
    
    // MARK: - Methods
    
    private func setTimer() {
        guard let startDate = self.startDate, let targetDate = self.targetDate else {
            return
        }
        
        self.timer?.invalidate()
        self.timer = nil
        
        let timeInterval = abs(targetDate.timeIntervalSince(startDate))/360 // time interval for 1 degrees filling
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.updateValue), userInfo: nil, repeats: true)
    }
    
    // MARK: - Actions
    
    @objc private func updateValue() {
        self.value = Float(self.timeProgress)
        
        if self.timeProgress == 1 {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
}
