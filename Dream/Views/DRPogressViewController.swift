//
//  DRPogressViewController.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 17.02.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DRProgressView: UIView {
    
    let dateShapeLayer    = CAShapeLayer()
    let expenseShapeLayer = CAShapeLayer()
    let percentageLabel   = UILabel()
    var timer: Timer?
    
    let expenseLineWidth: CGFloat  = 35
    let dateLineWidth   : CGFloat  = 23
    
    var dream: Dream? {
        didSet {
            
            updateExpense()
            //strokeAnimation(for: dateShapeLayer,    with: dateProgress,    animate: true)
            //strokeAnimation(for: expenseShapeLayer, with: expenseProgress, animate: true)

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    private func setup() {
        
        // Percentage label
        
        percentageLabel.font = UIFont.systemFont(ofSize: 47)
        percentageLabel.textAlignment = .center
        addSubview(percentageLabel)
        percentageLabel.frame  = CGRect(x: 0, y: 0, width: 120, height: 100)
        percentageLabel.center =  CGPoint(x: frame.width/2, y: frame.height/2)
        
        // Expense layer
        
        let expenseLayerRadius = (260/375*(self.frame.width > self.frame.height ? self.frame.height : self.frame.width)-expenseLineWidth)/2
        
        
        setupCircleShapeLayer(layer: expenseShapeLayer, lineWidth: expenseLineWidth, radius: expenseLayerRadius, strokeColor: UIColor.intensiveRed.cgColor, bgStrokeColor: UIColor.lightGray.withAlphaComponent(0.1).cgColor)
        
        // Date layer
        
        let dateLayerRadius = (335/375*(frame.width > frame.height ? frame.height : frame.width)-dateLineWidth)/2
        
        setupCircleShapeLayer(layer: dateShapeLayer, lineWidth: dateLineWidth, radius: dateLayerRadius, strokeColor: UIColor.purpleRed.cgColor, bgStrokeColor: UIColor.lightGray.withAlphaComponent(0.1).cgColor)
        
        // Timer
        let targetDate = dream?.targetDate ?? Date()
        let startDate  = dream?.startDate  ?? Date()

        let deltaYear = abs((targetDate.timeIntervalSince(startDate))/60)
        
        timer = Timer.scheduledTimer(timeInterval: deltaYear, target: self, selector: #selector(updateDateProgress), userInfo: nil, repeats: true)
    }

    
    @objc private func updateDateProgress() {
        let dateProgress = Double().progress(between: dream?.startDate, and: dream?.targetDate)
        
        if dateProgress == 1 {
            timer?.invalidate()
            return
        }
        
        DispatchQueue.main.async {
            self.dateShapeLayer.strokeEnd = CGFloat(dateProgress)
        }
    }
    
    private func updateExpense() {
        let expenseProgress = Double().progress(between: dream?.currentCredits, and: dream?.targetCredits)

        expenseShapeLayer.strokeEnd = CGFloat(expenseProgress)
        percentageLabel  .text      = " \(Int(expenseProgress * 100))%"
    }
    
    private func setupCircleShapeLayer(layer: CAShapeLayer, lineWidth: CGFloat, radius: CGFloat, strokeColor: CGColor, bgStrokeColor: CGColor) {
        
        let backgroundLayer = CAShapeLayer()
        let center          = CGPoint(x: frame.width/2, y: frame.height/2)
        let startAngle      = -CGFloat.pi / 2
        let endAngle        = 2 * CGFloat.pi
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
       
        backgroundLayer.path        = circularPath.cgPath
        backgroundLayer.strokeColor = bgStrokeColor
        backgroundLayer.lineWidth   = lineWidth
        backgroundLayer.fillColor   = UIColor.clear.cgColor
        backgroundLayer.lineCap     = kCALineCapRound
        
        self.layer.addSublayer(backgroundLayer)
        
        layer.path        = circularPath.cgPath
        layer.strokeColor = strokeColor
        layer.lineWidth   = lineWidth
        layer.fillColor   = UIColor.clear.cgColor
        layer.lineCap     = kCALineCapRound
        layer.strokeEnd   = 0
        
        self.layer.addSublayer(layer)
    }
    
    private func opacityAnimation(for layer: CAShapeLayer, animate: Bool) {
        if !animate {
            layer.removeAnimation(forKey: "opacityAnimation")
            return
        }
        
        let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        
        pulseAnimation.duration       = 0.7
        pulseAnimation.fromValue      = 0.3
        pulseAnimation.toValue        = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses   = true
        pulseAnimation.repeatCount    = Float.infinity
        
        layer.add(pulseAnimation, forKey: "opacityAnimation")
    }
    
    private func strokeAnimation(for layer: CAShapeLayer, with value: Double, animate: Bool) {
        if !animate {
            layer.removeAnimation(forKey: "strokeAnimation")
            return
        }

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")

        basicAnimation.toValue               = value
        basicAnimation.duration              = 2*value
        basicAnimation.fillMode              = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false

        layer.add(basicAnimation, forKey: "strokeAnimation")
    }
    
}
