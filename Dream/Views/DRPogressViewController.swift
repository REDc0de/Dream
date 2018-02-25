//
//  DRPogressViewController.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 17.02.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

class DRProgressView: UIView {
    
    // MARK: - Constants
    
    let dateShapeLayer    = CAShapeLayer()
    let expenseShapeLayer = CAShapeLayer()
    let percentageLabel   = UILabel()
    
    let expenseLineWidth: CGFloat  = 36
    let dateLineWidth   : CGFloat  = 28
    
    // MARK: - Properties
    
    public var dream: Dream? {
        didSet {
            updateExpenseProgress()
        }
    }
    
    // MARK: - Internal Properties

    private var timer: Timer?
    
    private var expenseProgress: Double {
        get{
            return Double().progress(between: dream?.currentCredits, and: dream?.targetCredits)
        }
    }
    
    private var dateProgress: Double {
        get{
            return Double().progress(between: dream?.startDate, and: dream?.targetDate)
        }
    }
    
    // MARK: - Lifecicle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    // MARK: - Methods
    
    private func setup() {
        
        // Percentage label
        percentageLabel.font          = UIFont.systemFont(ofSize: 47)
        percentageLabel.textAlignment = .center
        percentageLabel.frame         = CGRect(x: 0, y: 0, width: 140, height: 100)
        percentageLabel.center        = CGPoint(x: frame.width/2, y: frame.height/2)

        addSubview(percentageLabel)

        // Expense layer
        let expenseLayerRadius = (260/375*(self.frame.width > self.frame.height ? self.frame.height : self.frame.width)-expenseLineWidth)/2
        setupCircleShapeLayer(layer: expenseShapeLayer, lineWidth: expenseLineWidth, radius: expenseLayerRadius, strokeColor: self.tintColor.cgColor, bgStrokeColor: UIColor.lightGray.withAlphaComponent(0.1).cgColor)
        
        // Date layer
        let dateLayerRadius = (335/375*(frame.width > frame.height ? frame.height : frame.width)-dateLineWidth)/2
        setupCircleShapeLayer(layer: dateShapeLayer, lineWidth: dateLineWidth, radius: dateLayerRadius, strokeColor: self.tintColor.withAlphaComponent(0.2).cgColor, bgStrokeColor: UIColor.lightGray.withAlphaComponent(0.1).cgColor)
        
        // Timer
        let targetDate = dream?.targetDate ?? Date()
        let startDate  = dream?.startDate  ?? Date()
        let deltaYear  = abs((targetDate.timeIntervalSince(startDate))/60)

        timer = Timer.scheduledTimer(timeInterval: deltaYear, target: self, selector: #selector(updateDateProgress), userInfo: nil, repeats: true)
    }
    
    @objc private func updateDateProgress() {
        DispatchQueue.main.async {
            self.dateShapeLayer.strokeEnd = CGFloat(self.dateProgress)
        }
    
        if dateProgress == 1 {
            timer?.invalidate()
            return
        }
    }
    
    private func updateExpenseProgress() {
        expenseShapeLayer.strokeEnd = CGFloat(expenseProgress)
        percentageLabel  .text      = " \(Int(expenseProgress * 100))%"
    }
    
    private func setupCircleShapeLayer(layer: CAShapeLayer, lineWidth: CGFloat, radius: CGFloat, strokeColor: CGColor, bgStrokeColor: CGColor) {
        
        let backgroundLayer = CAShapeLayer()

        let circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
       
        backgroundLayer.path        = circularPath.cgPath
        backgroundLayer.strokeColor = bgStrokeColor
        backgroundLayer.lineWidth   = lineWidth
        backgroundLayer.fillColor   = UIColor.clear.cgColor
        backgroundLayer.lineCap     = kCALineCapRound
        backgroundLayer.position    = CGPoint(x: frame.width/2, y: frame.height/2)
        
        self.layer.addSublayer(backgroundLayer)
        
        layer.path        = circularPath.cgPath
        layer.strokeColor = strokeColor
        layer.lineWidth   = lineWidth
        layer.fillColor   = UIColor.clear.cgColor
        layer.lineCap     = kCALineCapRound
        layer.strokeEnd   = 0
        layer.position    = CGPoint(x: frame.width/2, y: frame.height/2)
        layer.transform   = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 0, 1)

        self.layer.addSublayer(layer)
    }
    
    private func opacityAnimation(for layer: CAShapeLayer) {
        let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        
        pulseAnimation.duration       = 0.6
        pulseAnimation.fromValue      = 0.3
        pulseAnimation.toValue        = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses   = true
        pulseAnimation.repeatCount    = Float.infinity
        
        layer.add(pulseAnimation, forKey: "opacityAnimation")
    }
    
    private func strokeAnimation(for layer: CAShapeLayer, with value: Double) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")

        basicAnimation.toValue               = value
        basicAnimation.duration              = 2*value
        basicAnimation.fillMode              = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false

        layer.add(basicAnimation, forKey: "strokeAnimation")
    }
    
}
