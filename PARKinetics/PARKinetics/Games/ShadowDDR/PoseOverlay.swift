//
//  PoseOverlay.swift
//  PARKinetics
//
//  Created by Kai Sackville-Hii on 2019-11-19.
//  Copyright © 2019 Kai Sackville-Hii. All rights reserved.
//

import Foundation
import UIKit

class PoseOverlay : UIView {
    let line = CAShapeLayer()
    let linePath = UIBezierPath()
    
    public var sourX: CGFloat = 5.0
    public var sourY: CGFloat = 5.0
    public var destX: CGFloat = 50.0
    public var destY: CGFloat = 50.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0.0, alpha: 0.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData() {
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        print(sourX)
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(UIColor.blue.cgColor)
            context.setLineWidth(3)
            context.beginPath()
            context.move(to: CGPoint(x: sourX ,y: sourY)) // This would be oldX, oldY
            context.addLine(to: CGPoint(x: destX, y: destY)) // This would be newX, newY
            context.strokePath()
        }
    }
}
