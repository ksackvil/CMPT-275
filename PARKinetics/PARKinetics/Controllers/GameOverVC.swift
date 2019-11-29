//
//  GameOverVC.swift
//  PARKinetics
//
//  Created by TANKER on 2019-10-04.
//  Copyright © 2019 TANKER. All rights reserved.
//
//  Description:
//      View controller for the game over scene, will be rendered after
//      compleation of every game
//
//  Contributors:
//      Kai Sackville-Hii
//          - File creation
//          - segues to home and back to game
//      Takunda Mwinjilo
//          - updating score
//

import Foundation
import UIKit

class GameOverVC: UIViewController {
    // MARK: Vars
    var score:Double = -1 // resulting score of the played game
    
    // MARK: Outlets
    @IBOutlet weak var gameScoreLabel: UILabel! // label for game score
    
    // DES: handler for calling unwind segue to home
    // PRE: unwindToHome segue exists
    // POST: render root parent view controller (home)
    @IBAction func goToHome(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    // MARK: Overides
    // DES: called after view appears
    // PRE: score is set from sender
    // POST: score is updated into view
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        print(UIScreen.main.bounds,screenSize.width, screenSize.height)
        let scaleX = screenSize.width / 768//768 is ipadPro screen width
        let scaleY = screenSize.height / 1024 //1024 is ipadPro screen height
        self.view.transform = CGAffineTransform.identity.scaledBy(x: scaleX, y: scaleY)
        gameScoreLabel.text = "\(Int(score * 1000))"
        print(score)
    }
}
