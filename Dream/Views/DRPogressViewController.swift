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
    
    let expenseLineWidth: CGFloat  = 35
    let dateLineWidth   : CGFloat  = 23
    
    var dream: Dream? {
        didSet {
            
            let dateProgress    = Double().progress(between: dream?.startDate,      and: dream?.targetDate   )
            let expenseProgress = Double().progress(between: dream?.currentCredits, and: dream?.targetCredits)
            
            strokeAnimation(for: dateShapeLayer,    with: dateProgress,    animate: true)
            strokeAnimation(for: expenseShapeLayer, with: expenseProgress, animate: true)
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
        
        // Expense layer
        
        let expenseLayerRadius = (260/375*(self.frame.width > self.frame.height ? self.frame.height : self.frame.width)-expenseLineWidth)/2
        
        
        setupShapeLayer(layer: expenseShapeLayer, lineWidth: expenseLineWidth, radius: expenseLayerRadius, strokeColor: UIColor.intensiveRed.cgColor, bgStrokeColor: UIColor.lightGray.withAlphaComponent(0.1).cgColor)
        
        // Date layer
        
        let dateLayerRadius = (335/375*(frame.width > frame.height ? frame.height : frame.width)-dateLineWidth)/2
        
        setupShapeLayer(layer: dateShapeLayer, lineWidth: dateLineWidth, radius: dateLayerRadius, strokeColor: UIColor.purpleRed.cgColor, bgStrokeColor: UIColor.lightGray.withAlphaComponent(0.1).cgColor)
    }
    
    private func setupShapeLayer(layer: CAShapeLayer, lineWidth: CGFloat, radius: CGFloat, strokeColor: CGColor, bgStrokeColor: CGColor) {
        
        let backgroundLayer = CAShapeLayer()
        
        let center     = CGPoint(x: frame.width/2, y: frame.height/2)
        let radius     = radius
        let startAngle = -CGFloat.pi / 2
        let endAngle   = 2 * CGFloat.pi
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        backgroundLayer.path = circularPath.cgPath
        
        backgroundLayer.strokeColor = bgStrokeColor
        backgroundLayer.lineWidth   = lineWidth
        backgroundLayer.fillColor   = UIColor.clear.cgColor
        backgroundLayer.lineCap     = kCALineCapRound
        self.layer.addSublayer(backgroundLayer)
        
        layer.path = circularPath.cgPath
        
        layer.strokeColor = strokeColor
        layer.lineWidth   = lineWidth
        layer.fillColor   = UIColor.clear.cgColor
        layer.lineCap     = kCALineCapRound
        layer.strokeEnd   = 0
        
        self.layer.addSublayer(layer)
    }
    
    private func opacityAnimation(for layer: CAShapeLayer, animate: Bool) {
        
        if !animate {
            layer.removeAnimation(forKey: "animateOpacity")
            return
        }
        
        let pulseAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        pulseAnimation.duration       = 0.7
        pulseAnimation.fromValue      = 0.3
        pulseAnimation.toValue        = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses   = true
        pulseAnimation.repeatCount    = Float.infinity
        layer.add(pulseAnimation, forKey: "animateOpacity")
    }
    
    private func strokeAnimation(for layer: CAShapeLayer, with value: Double, animate: Bool) {
        
        if !animate {
            layer.removeAnimation(forKey: "animateStroke")
            return
        }
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue               = value
        basicAnimation.duration              = 2*value
        basicAnimation.fillMode              = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        layer.add(basicAnimation, forKey: "animateStroke")
    }
    
}
