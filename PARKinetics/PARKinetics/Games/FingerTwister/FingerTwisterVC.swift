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
//import SwiftUI
import Foundation

class FingerTwisterVC: UIViewController {
    
    override func viewDidLoad() {

        super.viewDidLoad()
        //buttons.randomElement()
        self.view.isMultipleTouchEnabled = true
        buttons.forEach {
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.black.cgColor
        }
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "FingerTwisterBlank-2.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
   
    
   /* override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }*/
    
    /*override func viewWillDisappear (_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }*/
    
    
    
    public var checkOn: [Int] = [0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0]
    public var checkTouched: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    public var correctTap = 0
    var j = 0
    var i = 0
    var k = 0
    //var start = 0
    //var startTimer = Timer()
    
    var gameTime = 5
    var gameTimer = Timer()
    
    /*                gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(FingerTwisterVC.timerFunc), userInfo: nil, repeats: true) */ //waiting initialize Func
    
    
    @objc func timerFunc() {
        
        gameTime -= 1
        if gameTime == 0 {
            gameTimer.invalidate()
            print("TIME IS zero")
            //RESET FUNCTION HAS TO GO INSIDE
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
        }
        else {
            print("failure")
        }
    }

    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
