/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import SpriteKit
import AVFoundation
import Foundation

class FingerTwisterVC: UIViewController {
    
    
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        music(fileNamed:"Queen.mp3")
        self.view.isMultipleTouchEnabled = true
        buttons.forEach {
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.black.cgColor
        }
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "FingerTwisterBlank-2.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        Reset()
        
    }
    

    public var checkOn: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    public var checkTouched: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    public var correctTap = 0
    public var noteCount:Double = 0
    public var succefulNote:Double = 0
    var score:Double=0.0
    var j = 0
    var i = 0
    var k = 0
    //var start = 0
    //var startTimer = Timer()
    
    
    var gameTimer = Timer()
    var gameTime = 5

    
    
    @objc func timerFunc() {
        
        gameTime -= 1
        if gameTime == 0 {
            gameTimer.invalidate()
            print("TIME IS zero")
             Reset()
            
        }
    }
    
    @IBOutlet var buttons: [UIButton]!
    
    @IBAction func touchedDown(_ sender: UIButton) {
        

        sender.isSelected = !sender.isSelected
        //let index = buttons.firstIndex(of: sender)!
        for i in buttons.indices {
            if buttons[i].isHighlighted{
                checkTouched[i] = 1
                print("this",checkTouched[i])
                j = 0
                while (j < 16){
                    print("touchedDown",checkTouched[j])
                    j+=1
                }
            }
        }
        successfulNote()
    }
    
    public func successfulNote(){
        k = 0
        i = 0
        j = 0
        while (k < 16){
            if checkTouched[k]==1{
                print("yes")
            }
            else{
         //       print("no")
            }
            k+=1
        }
        while (i < 16) {
            
            if checkOn[i]==1{
               
                print("inside",checkTouched[i])
                if checkOn[i] != checkTouched[i]{
                    correctTap = 0
                    while (j < 16){
                        checkTouched[j] = 0
                        j+=1
                    }
                }
                else {
                    correctTap = 1
                }
            }
          
            i+=1
        }
        if correctTap==1{
            print("success")
            succefulNote+=1
            //(noteCount/totalnote )
            //Reset()
        }
        else {
            print("failure")
        }
    }
    //TK -Display the buttons to be pressed
    @objc func initialize() {
        
        var i = 0
        correctTap = 0
        while i<4 {//4 can be changed to however many tiles we want pressed
            let n = Int.random(in: 0 ... 15)
            if checkOn[n] == 0 {
                checkOn[n] = 1
                buttons[n].backgroundColor = .yellow
                print("Lighting up Buttons")
                i += 1
            }
        }
       
//        delay(bySeconds: 2) {
//            i = 0
//            while (i<16){
//                self.buttons[i].backgroundColor = .gray
//                i+=1
//            }
//        }
    }
    
    public func Reset()
    {
        noteCount+=1
        
        if noteCount >= 8 {
            
            audioPlayer.stop() //@Negar: Stop the Song
            score=(succefulNote/noteCount)*100
            print("score" )
            //GAMEOVER SCREEN
            //SWITCH TO THE PROFILE SCREEN 
        }
        checkOn = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        checkTouched = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        var i = 0
        i = 0
        while (i<16){
            self.buttons[i].backgroundColor = .gray
            print("GREY")
            i+=1
        }
        delay(bySeconds: 1) {
            self.gameTime = 4
            self.gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self,selector:#selector(FingerTwisterVC.timerFunc), userInfo: nil, repeats: true)  //waiting initialize Func
            self.initialize()
            print("DELAY")
        }
      
        
    }
    
    func music(fileNamed: String)
    {
        let sound = Bundle.main.url(forResource: fileNamed, withExtension: nil)
        guard let newUrl = sound
            else{
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
    override var prefersStatusBarHidden: Bool {
        return true
    }
    

}

//TK -Function To help generate delay. Only works for calling thread. does not delay other threads
public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
    let dispatchTime = DispatchTime.now() + seconds
    dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
}

public enum DispatchLevel {
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

    
    

    


