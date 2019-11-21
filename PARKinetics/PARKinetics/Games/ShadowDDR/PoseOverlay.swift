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
    
    public var sourX: CGFloat = 0.0
    public var sourY: CGFloat = 0.0
    public var destX: CGFloat = 0.5
    public var destY: CGFloat = 0.5
    
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
        if let context = UIGraphicsGetCurrentContext() {
            context.setStrokeColor(UIColor.blue.cgColor)
            context.setLineWidth(20)
            context.beginPath()
            context.move(to: CGPoint(x: sourX*self.frame.width ,y: sourY*self.frame.height)) // This would be oldX, oldY
            context.addLine(to: CGPoint(x: destX*self.frame.width, y: destY*self.frame.height)) // This would be newX, newY
            context.strokePath()
        }
    }
}
