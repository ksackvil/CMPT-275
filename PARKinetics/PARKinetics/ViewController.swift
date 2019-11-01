//
//  ViewController.swift
//  PARKinetics
//
//  Created by Kai Sackville-Hii on 2019-10-04.
//  Copyright © 2019 Kai Sackville-Hii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var fingerTwister: UIButton!
    @IBOutlet weak var fingerTwisterLabel: UILabel!
    @IBOutlet weak var adventureStory: UIButton!
    @IBOutlet weak var adventureStoryLabel: UILabel!
    @IBOutlet weak var shadowDdr: UIButton!
    @IBOutlet weak var shadowDdrLabel: UILabel!
    @IBOutlet weak var toolBar: UIBarButtonItem!
    
    
    @IBOutlet weak var userProgress: UIView!
    @IBOutlet weak var userProgLabel: UILabel!
    //    @IBOutlet weak var userProgress: UIView!
//    @IBOutlet weak var userProgLabel: UILabel!

    let userProgressCornerRadius: CGFloat = 100
    let userProgressLayer: CAShapeLayer = CAShapeLayer()
    let userProgressInnerLayer: CAShapeLayer = CAShapeLayer()

    var userProgressBorderLayer: CAShapeLayer = CAShapeLayer()


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round button corners
        fingerTwister.layer.cornerRadius = 10
        fingerTwister.clipsToBounds = true
        fingerTwister.tag = 1
        adventureStory.layer.cornerRadius = 10
        adventureStory.clipsToBounds = true
        adventureStory.tag = 2
        shadowDdr.layer.cornerRadius = 10
        shadowDdr.clipsToBounds = true
        shadowDdr.tag = 3
        
        // Make font labels bold
        fingerTwister.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        adventureStory.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        shadowDdr.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        
        drawUserProgressLayer()
        updateUserProgress(inc: 200.0)
        userProgLabel.layer.zPosition = 1
    }
    
    private func drawUserProgressLayer() {
        let bezierPath = UIBezierPath(roundedRect: userProgress.bounds, cornerRadius: userProgressCornerRadius)

        bezierPath.close()
        userProgressBorderLayer.path = bezierPath.cgPath
        userProgressBorderLayer.fillColor = UIColor.white.cgColor
        userProgressBorderLayer.strokeEnd = 0

        let innerBezierPath = UIBezierPath(roundedRect: CGRect( x: 2, y: 2, width: userProgress.bounds.width-4, height: userProgress.bounds.height-4), cornerRadius: userProgressCornerRadius)

        innerBezierPath.close()
        userProgressInnerLayer.path = innerBezierPath.cgPath
        userProgressInnerLayer.fillColor = UIColor(red: 42, green: 44, blue: 46).cgColor
        userProgressInnerLayer.strokeEnd = 0

        userProgress.layer.addSublayer(userProgressBorderLayer)
        userProgress.layer.addSublayer(userProgressInnerLayer)
    }

    public func updateUserProgress(inc: CGFloat) {

        if (inc <= userProgress.bounds.width - 10) {
            userProgressLayer.removeFromSuperlayer()

            let bezierPathProg = UIBezierPath(roundedRect: CGRect( x: 1.4, y: 2, width: inc, height: userProgress.bounds.height-4), cornerRadius: userProgressCornerRadius)
            bezierPathProg.close()
            userProgressLayer.path = bezierPathProg.cgPath
            userProgressLayer.fillColor = UIColor(red: 255, green: 141, blue: 156).cgColor
            userProgress.layer.addSublayer(userProgressLayer)

        }
    }

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
