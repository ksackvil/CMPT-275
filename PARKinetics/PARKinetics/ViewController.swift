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
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var adventureStoryView: UIView!
    @IBOutlet weak var fingerTwisterView: UIView!
    @IBOutlet weak var shadowDdrView: UIView!

    
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
        
        adventureStoryView.isHidden = true
        fingerTwisterView.isHidden = true
        shadowDdrView.isHidden = true
        
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.3, options: [], animations: {
            self.mainTitle.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6, animations: {
                self.mainTitle.transform = CGAffineTransform(translationX: 0, y: -230)
            })
        }, completion: {_ in
            UIView.transition(with: self.adventureStoryView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.adventureStoryView.isHidden = false
            }, completion: nil)
            UIView.transition(with: self.fingerTwisterView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.fingerTwisterView.isHidden = false
            }, completion: nil)
            UIView.transition(with: self.shadowDdrView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.shadowDdrView.isHidden = false
            }, completion: nil)
        })
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
