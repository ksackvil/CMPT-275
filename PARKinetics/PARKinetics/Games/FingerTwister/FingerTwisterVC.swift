//
//  FingerTwisterVC.swift
//  PARKinetics
//
//  Created by TANKER on 2019-10-04.
//  Copyright © 2019 TANKER. All rights reserved.
//
//  Contributors:
//      Kai Sackville-Hii
//          - File creation
//          - View segues
//          - Game over view
//          - Button linking and creation
//      Armaan Bandali
//          - Main game view and background
//          - Game logic including successful note check, button logic, and
//            reset
//          - General linking of functions
//      Negar Hariri
//          - Audio implementation
//          - View timing functions
//          - General game logic functions
//      Takunda Mwinjilo
//          - Delay and button initialization between notes
//          - Code formatting and documentation
//          - Audio debugging
//      Rachel Djauhari
//          - Audio base code and audio file management
//
//


import UIKit
import SpriteKit
import AVFoundation
import Foundation

class FingerTwisterVC: UIViewController {
    
    // MARK: Vars
    //Song player
    var audioPlayer = AVAudioPlayer() //Correct tiles to press
    var checkOn: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] //tiles currently pressed
    var checkTouched: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] //whether tap is correct or not
    var correctTap = 0 //How many tiles have been displayed to touch
    var noteCount:Double = 0 //How many tiles were successfully pressed
    var correctNoteCount:Double = 0
    var score:Double=0.0 //Timer seperating game rounds
    var gameTimer = Timer() //How many rounds the game will go for
    var gameTime = 5 //bool to check whether menu button was pressed
    
    // MARK: Outlets
    @IBOutlet var buttons: [UIButton]!
    
    // MARK: Overides
    // DES: Main view rendering with background
    // PRE: View loaded from main menu segue
    // POST: Background loaded, multiple touches enabled, call to button initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        music(fileNamed:"Queen.mp3")
        self.view.isMultipleTouchEnabled = true
        buttons.forEach {
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.black.cgColor
            $0.addTarget(self, action: #selector(touchedDown), for: .touchDown)
            $0.addTarget(self, action: #selector(touchedUp), for: .touchUpInside)
        }
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "FingerTwisterBlank-2.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.modalDismissHandler), name: NSNotification.Name(rawValue: "modalDissmised"), object: nil)
        Reset()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // DES: Hides toolbar
    // PRE: View loaded from main menu segue
    // POST: Toolbar hidden
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    //DES Notes which buttons are currently pressed checks if this is the correct sequence.
    @IBAction func touchedDown(_ sender: UIButton) {
        print("\(sender.tag) Touched Down")
        checkTouched[sender.tag] = 1;
        successfulNote() //Check to see if all notes were touched successfully
    }
    //DES Notes which buttons were released checks if this is the correct sequence
    @IBAction func touchedUp(_ sender: UIButton) {
        print("\(sender.tag) Touched Up")
        checkTouched[sender.tag] = 0;
        successfulNote() //Check to see if all notes were touched successfully
    }
    
    //DES:  Pauses game when menu button is pressed
    //PRE:  Timers running and audio playing
    //POST: Timers and audio paused
    @IBAction func menuButtonPressed(_ sender: Any) {
        gameTimer.invalidate()
        audioPlayer.pause()
    }
    
    // MARK: Functions
    //DES:  unpauses game when menu is exited
    //PRE:  Timers and audio paused
    //POST: Audio plays again and round is reset
    @objc func modalDismissHandler() {
        audioPlayer.play()
        Reset()
    }
    
    //DES:  Counts down time until next round and resets board
    @objc func timerFunc() {
        gameTime -= 1
        if gameTime == 0 {
            gameTimer.invalidate()
            Reset()
        }
    }
    
    func successfulNote() {
        var correct: Int = 0
        for i in 0...15 {
            if checkTouched[i] == 1 && checkOn[i] == checkTouched[i] {
                correct += 1;
            }
        }
        if correct > correctTap {
            correctTap = correct
        }
    }
    
    //DES: Highlight Buttons to be pressed
    @objc func initialize() {
        checkOn = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        checkTouched = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        self.buttons.forEach {
            $0.backgroundColor = .gray
        }
        for i in 0...3 {
            let n = (i * 4) + Int.random(in: 0 ... 3)
            checkOn[n] = 1
        }
        for j in 0...15 {
            if checkOn[buttons[j].tag] == 1 {
                buttons[j].backgroundColor = .yellow
            }
        }
    }
    
    //DES: Reset round variables
    func Reset()
    {
        noteCount+=1
        correctNoteCount += Double(correctTap)
        if noteCount >= 4 {
            audioPlayer.stop() //@Negar: Stop the Song
            gameTimer.invalidate()
            score=(correctNoteCount/(noteCount * 4))*100
            print("score" )
            gameOverHandler(result: score)
        }
        else {
            delay(bySeconds: 1) {
                self.gameTime = 4
                self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self,selector:#selector(FingerTwisterVC.timerFunc), userInfo: nil, repeats: true)  //waiting initialize Func
                self.initialize()
            }
        }
    }
    
    //DES: obtain music for game and begin playing it
    func music(fileNamed: String) {
        let sound = Bundle.main.url(forResource: fileNamed, withExtension: nil)
        guard let newUrl = sound else {
            print(" Could not find the file Called \(fileNamed)")
            return
            
        }
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: newUrl)
            audioPlayer.numberOfLoops = 1 //Number of loop until we stop it
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
        }
        catch let error as NSError{
            print(error.description)
        }
    }
    
    //DES: Transfer score for game to game over screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is GameOverVC
        {
            let vc = segue.destination as? GameOverVC
            vc?.score = self.score
        }
    }
    
    func gameOverHandler(result:Double) {
        //Upload game result to Firebase realtime databse
        let defaults = UserDefaults.standard
        let userKey = defaults.string(forKey: "uid")
        if(userKey != nil){
            DbHelper.uploadGame(uid: userKey!, type: "FT", balance: "0", facial: "0", speech: "0", dexterity: String(Int(score)), posture: "0")
            print("Uploaded game data");
        }
        performSegue(withIdentifier: "FingerTwisterGO", sender: self)
    }
}

// MARK: Class helpers
//DES: Function To help generate delay. Code in braces is executed after delay period
func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
    let dispatchTime = DispatchTime.now() + seconds
    dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
}

enum DispatchLevel {
    case main, userInteractive, userInitiated, utility, background
    var dispatchQueue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}

    
    

    


