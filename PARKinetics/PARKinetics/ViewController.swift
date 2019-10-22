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
    }
}

