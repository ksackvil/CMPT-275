//
//  GameMenuVC.swift
//  PARKinetics
//
//  Created by TANKER on 2019-10-04.
//  Copyright © 2019 TANKER. All rights reserved.
//
//  Contributors:
//      Kai Sackville-Hii
//          - File creation
//          - segues
//          - button styling
//

import Foundation
import UIKit

class GameMenuVC: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var mainMenu: UIButton! // button to go home
    @IBOutlet weak var resume: UIButton! // button to resume game
    
    // MARK: Actions
    // DES: renders when resume button pressed
    // PRE: resume button exists
    // POST: dissmises modal and sends update notification to destinatnion
    @IBAction func closeModal(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalDissmised"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    // DES: renders when menu button pressed
    // PRE: Unwind segue exists
    // POST: unwinds to home screen
    @IBAction func goToHome(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHomeFromGameMenu", sender: self)
    }
    
    // MARK: Overrides
    // DES: called after view loads
    // PRE: UI elements exists
    // POST: buttons are rounded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // round buttons
        mainMenu.layer.cornerRadius = 10
        mainMenu.clipsToBounds = true
        mainMenu.tag = 1
        resume.layer.cornerRadius = 10
        resume.clipsToBounds = true
        resume.tag = 1
    }
}
