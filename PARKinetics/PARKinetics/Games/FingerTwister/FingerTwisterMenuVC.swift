 //
//  FingerTwisterMenuVC.swift
//  PARKinetics
//
//  Created by Negar Hariri on 2019-11-01.
//  Copyright © 2019 Kai Sackville-Hii. All rights reserved.
//

 import Foundation
 import UIKit
 import SpriteKit
 
 class FingerTwisterMenuVC: UIViewController {
    
    @IBAction func HomepagePressed(_ sender:UIButton) {
        print("Home Page pressed")
    self.performSegue(withIdentifier: "HomepageSegue", sender:self)
        
    }
    
    
    @IBAction func ResumePressed(_ sender: UIButton) {
        print("Resume pressed")
    self.performSegue(withIdentifier: "ResumeSegue", sender:self)
        
        
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        
        
    }
    
   
  
    
    
 }
