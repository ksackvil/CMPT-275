//
//  GameOverVC.swift
//  PARKinetics
//
//  Created by Kai Sackville-Hii on 2019-11-03.
//  Copyright © 2019 Kai Sackville-Hii. All rights reserved.
//

import Foundation
import UIKit

class GameOverVC: UIViewController {
    var score:Double = -1
    
    @IBOutlet weak var gameScoreLabel: UILabel!
    
    @IBAction func goToHome(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameScoreLabel.text = "\(score)"
        print(score)
    }
}
