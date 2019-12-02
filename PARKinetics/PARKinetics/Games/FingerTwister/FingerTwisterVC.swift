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

extension UIView {
    enum GlowEffect: Float {
        case small = 0.4, normal = 2, big = 20
    }

    func doGlowAnimation(withColor color: UIColor, withEffect effect: GlowEffect = .normal) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 0
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero

        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 0
        glowAnimation.toValue = effect.rawValue
        glowAnimation.beginTime = CACurrentMediaTime()
        glowAnimation.duration = CFTimeInterval(0.5)
        glowAnimation.fillMode = .removed
        glowAnimation.autoreverses = true
        glowAnimation.isRemovedOnCompletion = true
        layer.add(glowAnimation, forKey: "shadowGlowingAnimation")
    }
}

class FingerTwisterVC: UIViewController {
    
    @IBOutlet weak var feedback: UIImageView! //Image used to show user feedback
    // MARK: Vars
    //Song player
    var audioPlayer : AVAudioPlayer!
    var checkOn: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] //tiles currently pressed
    var checkTouched: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] //whether tap is correct or not
    var correctTap:Double = 0 //How many tiles have been displayed to touch
    var currentRound:Double = 0 //How many tiles were successfully pressed
    var succefulNote:Double = 0 //Final game score as ratio of successfulNote to currentRound
    var score:Double=0.0 //Timer seperating game totalRounds
    var gameTimer = Timer() //How many totalRounds the game will go for
    var playing = false
    var success = false
    var song = ""
    var colour: UIColor?
    var glowing = false
    var totalRounds:Double = 0
    
    //TK music bpm
    var myTempo = Tempo(bpm:100)
    var period: Double = 0
    var correctNoteCount:Double = 0
    var bonus:Double = 1
    var multiplier:Double = 1.0

    // MARK: Outlets
    @IBOutlet var buttons: [UIButton]!
    
    // MARK: Overides
    // DES: Main view rendering with background
    // PRE: View loaded from main menu segue
    // POST: Background loaded, multiple touches enabled, call to button initialization=
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.main.bounds
        let scaleX = screenSize.width / 768//768 is ipadPro screen width
        let scaleY = screenSize.height / 1024 //1024 is ipadPro screen height
        self.view.transform = CGAffineTransform.identity.scaledBy(x: scaleX, y: scaleY)
        print(level)
        if (level==1){
            song = "Queen.mp3"
            myTempo = Tempo(bpm: 108)
            period = 2 * myTempo.seconds(duration: 1) //2 bars to touch correct tiles
            totalRounds = 9
        }
        else{
            song = "ABBA.mp3"
            myTempo = Tempo(bpm: 118)
            period = myTempo.seconds(duration: 1) //1 bar to touch correct tiles
            totalRounds = 20
            bonus = 1 / totalRounds
        }
        
        music(fileNamed: song)
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
        
        feedback.image = UIImage(named:"check.png")
        feedback.contentMode = .center
        feedback.alpha = 0
        
        view.addSubview(feedback)
        view.bringSubviewToFront(feedback) // ensures view is loaded in front of others
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
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    //DES: handles button being pressed
    @IBAction func touchedDown(_ sender: UIButton) {
         print("\(sender.tag) Touched")
         checkTouched[sender.tag] = 1;
        if checkOn[sender.tag] == 0 {
            sender.backgroundColor = .red
        }
         successfulNote() //Check to see if all notes were touched successfully
     }
    
    //DES: Handles buttons being released
    @IBAction func touchedUp(_ sender: UIButton) {
        print("\(sender.tag) Released")
        checkTouched[sender.tag] = 0;
        if sender.backgroundColor == .red {
            sender.backgroundColor = .gray
        }
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
    
    //DES: Checks how many notes have been successfully tapped and adds bonus where applicable
    func successfulNote() {
        var correct: Double = 0
        for i in 0...15 {
            if checkTouched[i] == 1 && checkOn[i] == checkTouched[i] {
                correct += 1;
            }
        }
        if correct > correctTap {
            correctTap = correct
            if (correctTap == Double(level + 1)) {
                multiplier += bonus
            }
            print("Correct Tap: \(correctTap)")
        }
    }
    
    //DES: Highlight tiles to be pressed and setup bonus score time
    @objc func initialize() {
        checkOn = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        checkTouched = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        correctTap = 0
        self.buttons.forEach {
            $0.backgroundColor = .gray
        }
        //Make sure notes are always from different column.
        var column = [0, 1, 2, 3]
        column = column.shuffled()
        for i in 0...level {
            let n = (column[i] * 4) + Int.random(in: 0 ... 3)
            checkOn[n] = 1
        }
        for j in 0...15 {
            if checkOn[buttons[j].tag] == 1 {
                buttons[j].backgroundColor = .yellow
                //self.buttons[j].doGlowAnimation(withColor: UIColor.white, withEffect: .big)
                delay(bySeconds: (0.5 * period) - 0.25) {
                    self.bonus = 1 / self.totalRounds
                    self.buttons[j].doGlowAnimation(withColor: UIColor.green, withEffect: .big)
                    self.bonus = 0;
                    delay(bySeconds: 1.0) {
                        self.flashFeedback()
                    }
                }
            }
        }
    }
    
    //DES: Reset round variables
    @objc func Reset()
    {
        //currentRound+=1
        correctNoteCount += correctTap
        if currentRound >= totalRounds {
            audioPlayer.stop() //@Negar: Stop the Song
            gameTimer.invalidate()
            print("Game END*********")
            print("correctNoteCount = \(correctNoteCount)")
            print("currentRound = \(currentRound)")
            print("level + 1 = \(level + 1)")
            score = correctNoteCount/(currentRound * Double(level + 1)) * 100
            print("score: \(score)" )
            gameOverHandler(result: score)
        }
        else {
            gameTimer = Timer.scheduledTimer(timeInterval: period, target: self,selector:#selector(FingerTwisterVC.Reset), userInfo: nil, repeats: false)
            currentRound += 1
            print("Note Count: \(currentRound)")
            initialize()
        }
    }

    //DES: obtain music for game and begin playing it
    func music(fileNamed: String) {
        print("here")
        let sound = Bundle.main.url(forResource: fileNamed, withExtension: nil)
        guard let newUrl = sound else {
            print(" Could not find the file Called \(fileNamed)")
            return
            
        }
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: newUrl)
            audioPlayer.numberOfLoops = 0 //Number of loop until we stop it
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 0.08
            audioPlayer.play()
        }
        catch let error as NSError{
            print(error.description)
        }
        playing = true
    }
    
    //DES: Transfer score for game to game over screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is GameOverVC
        {
            let vc = segue.destination as? GameOverVC
            vc?.score = self.score * self.multiplier
        }
    }
    
    //DES: flash icon to indicate game feedback
    private func flashFeedback() {
        if correctTap == 0.0{
            self.feedback.image = UIImage(named: "cross.png")
        } else {
            self.feedback.image = UIImage(named: "check.png")
        }
        
        UIView.animate(withDuration: 1, delay: 0.0 , animations: {
            self.feedback.alpha = 1
        }, completion: {_ in
            UIView.animate(withDuration: 1.2, delay: 0.0 , animations: {
                  self.feedback.alpha = 0
            })
        })
    }
    
    //DES: send scores to database
    func gameOverHandler(result:Double) {
        //Upload game result to Firebase realtime databse
        let defaults = UserDefaults.standard
        let userKey = defaults.string(forKey: "uid")
        if(userKey != nil){
            DbHelper.uploadGame(uid: userKey!, type: "FT", balance: "50", facial: "50", speech: "50", dexterity: String(Int(score)), posture: "50")
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
//DES: sets up music tempo to seconds to help match tile flashes to music
struct Tempo {
    var bpm: Double
    func seconds(duration: Double = 0.25) -> Double {
        return 1.0 / self.bpm * 60.0 * 4.0 * duration
    }
}
    

    


