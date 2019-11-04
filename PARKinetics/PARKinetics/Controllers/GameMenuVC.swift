//
//  GameMenuVC.swift
//  PARKinetics
//
//  Created by Kai Sackville-Hii on 2019-11-01.
//  Copyright © 2019 Kai Sackville-Hii. All rights reserved.
//

import Foundation
import UIKit

class GameMenuVC: UIViewController {
    
    @IBOutlet weak var mainMenu: UIButton!
    @IBOutlet weak var resume: UIButton!
    
    @IBAction func closeModal(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalDissmised"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainMenu.layer.cornerRadius = 10
        mainMenu.clipsToBounds = true
        mainMenu.tag = 1
        resume.layer.cornerRadius = 10
        resume.clipsToBounds = true
        resume.tag = 1
    }
}
