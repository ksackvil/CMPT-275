//
//  AdventureGameVC.swift
//  PARKinetics
//
//  Created by TANKER on 2019-10-04.
//  Copyright © 2019 TANKER. All rights reserved.
//
//  Contributors:
//      Armaan Bandali
//          - Main game logic, helper functions, and animation functions
//          - Story architecture and content
//          - General debugging and test cases
//          - Game view UI
//      Takunda Mwinjilo
//          - Game view layout
//          - Menu button and segues
//      Evan Huang
//          - Speech recognition implementation
//          - Game timer and synchronization
//          - General debugging
//
//

import UIKit
import Speech

class AdvantureGameVC: UIViewController {
    
    @IBOutlet weak var storyBox: UILabel! //speech recognition text

   // @IBOutlet weak var score: UILabel! //scoring
    
    @IBOutlet weak var leftTextBox: UILabel!
    
    @IBOutlet weak var storyText: UILabel!
    
    @IBOutlet weak var rightTextBox: UILabel!
    
    @IBOutlet weak var microphoneButton: UIButton!
    
    @IBAction func AdventureMenu(_ sender: Any) {
        print("button pressed")
    self.shouldPerformSegue(withIdentifier: "AdventureMenueSegue", sender: self)
    }
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var currentAnalysis: String = ""
    var incorrectMatch: Bool = false
    var audioDone : Bool = false
    var speechDetected = false
    
    //Scoring variables, get the final score by totalScore/fullScore
    var fullScore : Double = 0.0
    var totalScore : Double = 0.0
    var roundScore : Double = 10.0
    var score: Int = 0
    
    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    let AdventureStory1 = StoryList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        let screenSize: CGRect = UIScreen.main.bounds
        let scaleX = screenSize.width / 768//768 is ipadPro screen width
        let scaleY = screenSize.height / 1024 //1024 is ipadPro screen height
        self.view.transform = CGAffineTransform.identity.scaledBy(x: scaleX, y: scaleY)

 
        self.view.backgroundColor = UIColor.black
        backgroundImage.image = UIImage(named: "jungle")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        microphoneButton.isEnabled = false
        speechRecognizer!.delegate = self as? SFSpeechRecognizerDelegate
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            @unknown default:
                isButtonEnabled = false
                print("Unknown error")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
        
        createStory(adventureStoryList: AdventureStory1)
        AdventureStory1.currentStory = AdventureStory1.first
        //transitionStoryOut()
        self.leftTextBox.text = AdventureStory1.currentStory?.leftStory
        self.rightTextBox.text = AdventureStory1.currentStory?.rightStory
        self.storyBox.text = " "
        self.storyText.text = AdventureStory1.currentStory?.storyPlot
        transitionStoryIn()
    }
    
    @IBAction func microphoneTapped(_ sender: Any) {
        if !audioEngine.isRunning {
            print("audio running")
            startRecording()
            //microphoneButton.setTitle("Stop Recording", for: .normal)
            microphoneButton.tintColor = #colorLiteral(red: 1, green: 0.1713354463, blue: 0.1736028223, alpha: 1)
            self.incorrectMatch = false
        }
    }
    
    //Description: Begins recording and speech recognition processes
    //Pre: No current audio session. Microphone and speech recognition permissions are granted
    //Post: Performs speech analysis on user input speech and returns a best guess string
    func startRecording() {
        
        audioDone = false
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer!.recognitionTask(with:
            recognitionRequest, resultHandler: { (result, error) in
            
            print("In Recognition Task")
            
            if result != nil {
                
                self.currentAnalysis = (result?.bestTranscription.formattedString)!
                if(!self.audioDone){
                    self.storyBox.text = self.currentAnalysis
                }
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        Timer.scheduledTimer(withTimeInterval:
            4.0, repeats: false, block: { timer in
                self.audioDone = true
                self.incorrectMatch = false
                if self.audioEngine.isRunning {
                    self.audioEngine.stop()
                    recognitionRequest.endAudio()
                    //self.microphoneButton.isEnabled = false
                    inputNode.removeTap(onBus: 0)
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    
                    self.microphoneButton.isEnabled = true
                    self.microphoneButton.tintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                }
                self.testMatch(phrase: self.currentAnalysis)
        })
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        storyBox.text = "Say something, I'm listening!"
        
    }
    
    //Description: Tests the recognized speech against acceptable answers and progresses the story if true
    //Pre: Speech has been recognized and user has not spoken for 2 seconds
    //Post: Speech matches story strings and calls transition or returns false if speech did not match
    func testMatch (phrase: String)->Bool{
        let correctPhrase1 = AdventureStory1.currentStory?.leftStory
        let correctPhrase2 = AdventureStory1.currentStory?.rightStory
        if ((correctPhrase1 == phrase)||(correctPhrase2 == phrase)){
            //Successful match, increase fullScore, totalScore and reset roundScore
            totalScore += roundScore
            //Increase fullScore, set roundScore back to 10
            fullScore += 10
            roundScore = 10
            score = Int((totalScore/fullScore) * 100)
            
            if (correctPhrase1 == phrase){
                if AdventureStory1.currentStory!.gameOver{
                    chapterEnd()
                    print("FullSore: %d", fullScore)
                    print("TotalScore: %d", totalScore)
                    print("RoundScore: %d", roundScore)
                    print ("Score:" ,score)
                    return true
                }
                else{
                    AdventureStory1.currentStory = AdventureStory1.currentStory?.leftChild
                    transitionStoryOut()
                    self.incorrectMatch = false
                    
                    print("FullSore: %d", fullScore)
                    print("TotalScore: %d", totalScore)
                    print("RoundScore: %d", roundScore)
                    print ("Score:" ,score)
                    return true
                }
            }
            else{
                if AdventureStory1.currentStory!.gameOver{
                    chapterEnd()
                    print("FullSore: %d", fullScore)
                    print("TotalScore: %d", totalScore)
                    print("RoundScore: %d", roundScore)
                    print ("Score:" ,score)
                    return true
                }
                else{
                    AdventureStory1.currentStory = AdventureStory1.currentStory?.rightChild
                    transitionStoryOut()
                    self.incorrectMatch = false
                    print("FullSore: %d", fullScore)
                    print("TotalScore: %d", totalScore)
                    print("RoundScore: %d", roundScore)
                    print ("Score:" ,score)
                    return true
                }
            }
        }
        else{
            //Incorrect match, decrease the roundScore
            if(roundScore > 5){
                roundScore -= 1
                score = Int((totalScore + roundScore)/(fullScore + 10) * 100)
            }
            self.incorrectMatch = true
            self.storyBox.text = "Please try again"
            print("FullSore: %d", fullScore)
            print("TotalScore: %d", totalScore)
            print("RoundScore: %d", roundScore)
            print ("Score:" ,score)
            return false
        }
    }
    
    //Description: Hides all text in the current view
    //Pre: Recognized speech matched a story option
    //Post: All text is hidden and calls transitionStoryIn to reveal next part of story
    func transitionStoryOut(){
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.leftTextBox.alpha = 0.0
            self.rightTextBox.alpha = 0.0
            self.microphoneButton.alpha = 0.0
            self.storyBox.alpha = 0.0
            self.storyText.alpha = 0.0
        })
        while(true){
            if leftTextBox.alpha == 0.0{
                transitionStoryIn()
                break
            }
        }
    }
    
    //Description: Loads next part of story into text boxes and makes them visible with a fade in effect
    //Pre: previous story was transitioned out
    //Post: Next part of story transitioned in
    func transitionStoryIn(){
        self.leftTextBox.text = AdventureStory1.currentStory?.leftStory
        self.rightTextBox.text = AdventureStory1.currentStory?.rightStory
        self.storyBox.text = ""
        print("key",AdventureStory1.currentStory!.key)
        if AdventureStory1.currentStory!.gameOver{
            self.storyText.text = AdventureStory1.currentStory?.gameOverStory
            self.backgroundImage.removeFromSuperview()
        }
        else{
           self.backgroundImage.removeFromSuperview()
           self.storyText.text = AdventureStory1.currentStory?.storyPlot
           backgroundImage.image = UIImage(named: AdventureStory1.currentStory!.pictureFile)
           backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
           self.view.insertSubview(backgroundImage, at: 0)
        }

        UIView.animate(withDuration: 2.0, delay: 1.0, options: .curveEaseOut, animations: {
        self.leftTextBox.alpha = 1.0
        self.rightTextBox.alpha = 1.0
        self.microphoneButton.alpha = 1.0
        self.storyBox.alpha = 1.0
        self.storyText.alpha = 1.0
        })
    }
    
    //Description: Indicates the end of the chapter and displays a chapter end screen
    //Pre: Last story's right or left child is nil
    //Post: User moves to profile view
    func chapterEnd(){
        self.leftTextBox.alpha = 0.0
        self.rightTextBox.alpha = 0.0
        self.microphoneButton.alpha = 0.0
        self.storyBox.alpha = 0.0
        self.storyText.text = "Game Over"
    }
    
    //Description: Checks for speech recognition capabilities on target device
    //Pre: View was loaded
    //Post: Microphone button enabled or disabled
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    //DES: Transfer score for game to game over screen

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MenuVC
        {
            let vc = segue.destination as? MenuVC
            vc?.score = self.score
        }
    }
    

}
