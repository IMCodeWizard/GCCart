//
//  CustomView.swift
//  GCCart
//
//  Created by Ninja on 21/02/2019.
//  Copyright © 2019 JB Devs. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomView: UIView {
    
    let gradient = CAGradientLayer()
    var colors : [CGColor]?
    
    @IBInspectable public var color1: UIColor = .clear {
        didSet{
            setupGradient()
        }
    }
    @IBInspectable public var color2: UIColor = .clear {
        didSet{
            setupGradient()
        }
    }
    
    // Only override draw() if you perform custom drawing.
    override func draw(_ rect: CGRect) {
        // Drawing code
        colors = [color1.cgColor, color2.cgColor]
        setupGradient()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }
    
    // MARK: - Metohds
    func setupGradient() {
        gradient.frame = bounds
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0, y: 0.03)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.92)
        gradient.locations = [0, 0.9]
        gradient.opacity = 0.70
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    
}
