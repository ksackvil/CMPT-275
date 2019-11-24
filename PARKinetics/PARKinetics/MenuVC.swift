//
//  MenuVC.swift
//  
//
//  Created by Negar Hariri on 2019-11-23.
//

import UIKit

class MenuVC: UIViewController {

     var score:Double = -1
    @IBOutlet weak var gameScore: UILabel!
    
    
    
    @IBAction func ResumeToAdventure(_ sender: Any) {
        
        print("Resume To adventure")
        self.shouldPerformSegue(withIdentifier: "ResumeToAdventureSegue", sender: self)
    }
    
    @IBAction func Quit(_ sender: Any) {
        print("Quite pressed")
        
        self.shouldPerformSegue(withIdentifier: "quitTheAdventureGame", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        gameScore.text = "\(score)"
        print(score)
      
        // Do any additional setup after loading the view.
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
