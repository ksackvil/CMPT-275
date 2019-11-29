//
//  MenuVC.swift
//  
//
//  Created by Negar Hariri on 2019-11-25.
//

import Foundation
//
//  MenuVC.swift
//
//
//  Created by Negar Hariri on 2019-11-23.
//

import UIKit

class MenuVC: UIViewController {

     var score:Int = -1
    @IBOutlet weak var gameScore: UILabel!
    
//    @IBAction func closeModal(_ sender: Any) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalDissmised"), object: nil)
//        dismiss(animated: true, completion: nil)
//    }
//
    
    @IBAction func ResumeToAdventure(_ sender: Any) {
        
       NotificationCenter.default.post(name: NSNotification.Name(rawValue: "modalDissmised"), object: nil)
        dismiss(animated: true, completion: nil)
        print("Resume To adventure")
        //self.shouldPerformSegue(withIdentifier: "ResumeToAdventureSegue", sender: self)
    }
    
    @IBAction func Quit(_ sender: Any) {
        print("Quite pressed")
        //Upload game data to Firebase realtime database
        let defaults = UserDefaults.standard
        let userKey = defaults.string(forKey: "uid")
        if(userKey != nil && score != 0){
            DbHelper.uploadGame(uid: userKey!, type: "AG", balance: "50", facial: String(score), speech: String(score), dexterity: "50", posture: "50")
            print("Uploaded game data");
        }
        self.performSegue(withIdentifier: "unwindToHomeFromGameMenu2", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        let scaleX = screenSize.width / 768//768 is ipadPro screen width
        let scaleY = screenSize.height / 1024 //1024 is ipadPro screen height
        self.view.transform = CGAffineTransform.identity.scaledBy(x: scaleX, y: scaleY)
        gameScore.text = "\(score)"
        print(score)
      
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    

    
}

