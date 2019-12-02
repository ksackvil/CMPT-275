//
//  File.swift
//  PARKinetics
//
//  Created by Negar Hariri on 2019-11-27.
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

// Global variable to change finger twister level
var level: Int = 0

class FingerTwisterInst: UIViewController {

     
    // DES: handles segue to FingerTwister level 1
    @IBAction func Level(_ sender: Any) {
        level = 1
        performSegue(withIdentifier: "LevelOne", sender: sender)
    }
    
    // DES: handles segue to FingerTwister level 2
    @IBAction func LevelTwo(_ sender: Any) {
        level = 2
        performSegue(withIdentifier: "LevelTwo", sender: sender)
    }
    
    // DES: handles unwind to home screen
    @IBAction func backButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHomeFromFingerTwisterInst", sender: self)
    }
    
    // DES: Formats view to dynamically change depending on screen size
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        let scaleX = screenSize.width / 768//768 is ipadPro screen width
        let scaleY = screenSize.height / 1024 //1024 is ipadPro screen height
        self.view.transform = CGAffineTransform.identity.scaledBy(x: scaleX, y: scaleY)
    }
    
    // DES: will lock orientation to  portrait mode
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
}
