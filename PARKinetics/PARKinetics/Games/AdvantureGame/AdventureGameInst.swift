//
//  AdventureGameInst.swift
//  PARKinetics
//
//  Created by Kai Sackville-Hii on 2019-11-28.
//  Copyright © 2019 Kai Sackville-Hii. All rights reserved.
//
//  Description:
//      This file is the view controller for the Finger twister
//      instructions screen
//
//  Contributors:
//      Kai Sackville-Hii
//          - Ported to new storyboad layout
//      Negar Hariri
//          - File creation
//          - Implemented logic

import Foundation
import UIKit

class AdventureGameInst: UIViewController {

    // DES: handles unwind to home screen
    @IBAction func backButton1(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHomeFromAdventureStoryInst", sender: self)
    }
    
    // DES: Formats view to dynamically change depending on screen size
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        let screenSize: CGRect = UIScreen.main.bounds
        let scaleX = screenSize.width / 768//768 is ipadPro screen width
        let scaleY = screenSize.height / 1024 //1024 is ipadPro screen height
        self.view.transform = CGAffineTransform.identity.scaledBy(x: scaleX, y: scaleY)
    }
}
