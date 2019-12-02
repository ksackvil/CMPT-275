//
//  ShadowDDRInst.swift
//  PARKinetics
//
//  Created by Kai Sackville-Hii on 2019-11-29.
//  Copyright © 2019 Kai Sackville-Hii. All rights reserved.
//
//  Description:
//      This file is the view controller for the shadow DDR instructions screen
//
//  Contributors:
//      Kai Sackville-Hii
//          - File creation
//          - helper functions

import Foundation
import UIKit

class ShadownDDRInst: UIViewController {

    // DES: handles unwind to home screen
    @IBAction func backButton1(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHomeFromShadowDDR", sender: self)
    }
    
    // DES: Formats view to dynamically change depending on screen size
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        let scaleX = screenSize.width / 768//768 is ipadPro screen width
        let scaleY = screenSize.height / 1024 //1024 is ipadPro screen height
        self.view.transform = CGAffineTransform.identity.scaledBy(x: scaleX, y: scaleY)
    }
}
    


