//
//  UICircleProgressView.swift
//  Dream
//
//  Created by Bogdan Chaikovsky on 15.03.18.
//  Copyright © 2018 Bogdan Chaikovsky. All rights reserved.
//

import UIKit

@IBDesignable
class UICircleProgressView: UIView {
    
    // MARK: Internal properties
    
    fileprivate let shapeLayer = CACircleLayer()
    
    fileprivate var backgroundLayer: CACircleLayer? {
        return self.layer as? CACircleLayer
    }
    
    fileprivate var _value: Float?
    
    // MARK: Customization
    
    @IBInspectable
    open var lineColor: UIColor? {
        get {
            guard let color = self.shapeLayer.strokeColor else {
                return UIColor.white
            }
            return UIColor(cgColor: color)
        }
        set {
            self.shapeLayer.strokeColor = newValue?.cgColor
            self.shapeLayer.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    open var backgroundLineColor: UIColor? {
        get {
            guard let color = self.backgroundLayer?.strokeColor else {
                return UIColor.white
            }
            return UIColor(cgColor: color)
        }
        set {
            if let layer = self.backgroundLayer {
                layer.strokeColor = newValue?.cgColor
                layer.setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable
    open var lineWidth: Float {
        get {
            return Float(self.shapeLayer.lineWidth)
        }
        set {
            let width = CGFloat(newValue)
            
            self.shapeLayer.lineWidth = width
            self.backgroundLayer?.lineWidth = width
        }
    }
    
    @IBInspectable
    open var value: Float {
        get {
            return _value ?? 0
        }
        set {
            self.set(value: newValue, oldValue: self._value)
        }
    }
    
    // MARK: UIView
    
    override open class var layerClass: Swift.AnyClass {
        
        return CACircleLayer.self
    }
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.layer.addSublayer(self.shapeLayer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.layer.addSublayer(self.shapeLayer)
    }
    
    open override func layoutSubviews() {
        
        super.layoutSubviews()
        self.shapeLayer.frame = self.layer.bounds
    }
    
    // MARK: Methods
    
    open func set(value: Float, animationDuration: Double) {
        
        self.set(value: value, oldValue: self._value)
    }
    
    // MARK: Internal methods
    
    fileprivate func set(value: Float, oldValue: Float?) {
        
        var value = value
        
        if value < 0 {
            value = 0
        }
        else if value > 1 {
            value = 1
        }
        
        if oldValue != value {
            self.shapeLayer.strokeEnd = CGFloat(value)
            self._value = value
        }
    }
    
}


@IBDesignable
public class CACircleLayer: CAShapeLayer {
    
    // MARK: Internal
    
    fileprivate var needsPathUpdate = false
    
    fileprivate func setNeedsPathUpdate() {
        
        self.needsPathUpdate = true
        self.setNeedsDisplay()
    }
    
    // MARK: CALayer
    
    override public var bounds: CGRect {
        didSet {
            if self.bounds.isEmpty {
                self.path = nil
                return
            }
            if self.bounds == oldValue {
                return
            }
            self.setNeedsPathUpdate()
        }
    }
    
    override public var frame: CGRect {
        didSet {
            if self.frame.isEmpty {
                self.path = nil
                return
            }
            if self.frame.size == oldValue.size {
                return
            }
            self.setNeedsPathUpdate()
        }
    }
    
    override public var lineWidth: CGFloat {
        didSet {
            if oldValue != self.lineWidth {
                self.setNeedsPathUpdate()
            }
        }
    }
    
    override public func display() {
        
        super.display()
        
        if self.needsPathUpdate {
            self.path = self.layerPath()
            self.needsPathUpdate = false
        }
    }
    
    // MARK: Layer lifecycle
    
    override init(layer: Any) {
        
        super.init(layer: layer)
        self.setup()
    }
    
    override init() {
        
        super.init()
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        self.setup()
    }
    
    // MARK: Layer setup
    
    fileprivate func layerPath() -> CGPath {
        
        let path = CGMutablePath()
        
        path.addArc(
            center: CGPoint(x: self.bounds.midX, y: self.bounds.midY),
            radius: ceil(min(self.bounds.width / 2, self.bounds.height / 2) - self.lineWidth / 2) - 1,
            startAngle: .pi / -2,
            endAngle: .pi + .pi / 2,
            clockwise: false
        )
        
        return path
    }
    
    fileprivate func setup() {
        
        self.path = self.layerPath()
        self.strokeColor = UIColor.black.cgColor
        self.fillColor = self.backgroundColor
        self.lineCap = kCALineCapRound
    }
    
}


