//
//  ShadowDDRVC.swift
//  PARKinetics
//
//  Created by Kai Sackville-Hii on 2019-11-15.
//  Copyright © 2019 Kai Sackville-Hii. All rights reserved.
//
//  Description:
//      This file is the view controller of the ShadowDDR game

//  Contributors:
//      Kai Sackville-Hii
//          - File creation
//          - view setup and animations
//          - unwindToViewController() segue
//          - Video Capture session
//          - Gameplay
//      Evan Huang
//          - Score calculation
//          - Score uploading to Firebase

import UIKit
import Foundation
import Fritz

class ShadowDDRVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var feedback: UIImageView!              // Image which appears after success or failure of a pose
    var pe: PoseEstimate!                   // Stores all pose verification and estimation
    var pd: PoseData!                       // Stores info on each pose of the hard coded routine
    var gameTimer: Timer!                   // Timer user to finish each pose (15 sec), resets for each pose
    var maxPoseTime: Int = 5                // Time in seconds to successfully complete each pose
    var timeCount: Int = 0                  // Counts how many time timer loop was ran in one pose, if larger than
                                            //      maxPoseTime then pose has failed and next pose is loaded
    var captureSession: AVCaptureSession!   // Our video session handeler
    var isActive: Bool = false              // When true the pose estimator and game loop will run, else output is
                                            //      the the unaltered input video feed
    var poseItr: Int = 0                    // Defines which pose is currently in view, must be less than numPoses
    var numPoses: Int!                      // Max number of poses in this routine (set by PoseData obj)
    var poseSuccess: Bool = false           // True if current pose was correctly done
    var poseSuccessArray: [Bool]!           // Stores poseSuccess result for each pose (used to keep score)
    
    // Outlets
    @IBOutlet weak var previewView: UIImageView!    // displays the video output
    @IBOutlet weak var inst: UITextView!            // text which instructs user on pose
    @IBOutlet weak var poseView: UIImageView!       // cartoon of expected pose
    
    // Vars used for Fritz vision API
    lazy var poseModel = FritzVisionHumanPoseModelFast()
    lazy var poseSmoother = PoseSmoother<OneEuroPointFilter, HumanSkeleton>()
    var minPoseThreshold: Double = 0.4

    // MARK: Overides
    // DES: Hides toolbar
    // PRE: View loaded from main menu segue
    // POST: Toolbar hidden
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        let screenSize: CGRect = UIScreen.main.bounds
        let scaleX = screenSize.width / 768//768 is ipadPro screen width
        let scaleY = screenSize.height / 1024 //1024 is ipadPro screen height
        self.view.transform = CGAffineTransform.identity.scaledBy(x: scaleX, y: scaleY)
        
        // setup posedata object and grab number of poses loaded
        self.pd = PoseData()
        self.numPoses = self.pd.size()
        
        // setup the pose estimater and the score array
        self.pe = PoseEstimate()
        self.poseSuccessArray = [Bool](repeating: false, count:self.numPoses)
                
        // previewView which hosues the pose estimations
        previewView.contentMode = .scaleAspectFill
        previewView.clipsToBounds = true
        
        // View for feedback
        feedback = UIImageView(frame: view.bounds)
        feedback.image = UIImage(named:"correct.png")
        feedback.contentMode = .center
        feedback.alpha = 0
        
        view.addSubview(feedback)
        view.bringSubviewToFront(feedback) // ensures view is loaded in front of others

        // setup camera input
        self.setupOutput()
//        testWithImage();
        
        // start game at inital pose
        self.isActive = true
        inst.text = pd.textAt(pos: 0)
        poseView.image = pd.imageAt(pos: 0)
        startTimer()
    }
    
    //DES: Transfer score for game to game over screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is GameOverVC
        {
            let vc = segue.destination as? GameOverVC
            var tempScore: Double = 0
            
            for x in self.poseSuccessArray {
                if x {
                    tempScore += 1
                }
            }
            vc?.score = (tempScore / Double(self.numPoses))*100
        }
    }
    
    // DES: Sets up our view with subviews
    override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
//      previewView.frame = view.bounds
    }

    // DES: handle memory warnings
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }
    
    // MARK: Utils
    // DES: Handles animation for flashing feedback on successful pose
    private func flashFeedback(success: Bool) {
        if success {
            self.feedback.image = UIImage(named: "success.png")
        }
        else {
            self.feedback.image = UIImage(named: "fail.png")
        }
        
        UIView.animate(withDuration: 1, delay: 0.0 , animations: {
            self.feedback.alpha = 1
        }, completion: {_ in
            UIView.animate(withDuration: 1.2, delay: 0.0 , animations: {
                  self.feedback.alpha = 0
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.isActive = true
            }
        })
    }
    
    // DES: begins game timer looping every second, resets timeCout back to zero
    private func startTimer() {
        timeCount = 0
        gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
    }
}

// MARK: Output Video Handlers
extension ShadowDDRVC {
    // DES: Setup for our captureSession
    // POST: catptureSession is non nil
    private func setupOutput() {
        // our video session handeler
        self.captureSession = {
          let session = AVCaptureSession()

          guard
            let frontCamera = AVCaptureDevice.default(
                .builtInWideAngleCamera,
              for: .video,
              position: .front),
            let input = try? AVCaptureDeviceInput(device: frontCamera)
            else { return session }
          session.addInput(input)
          session.sessionPreset = .photo

          return session
        }()

        // Video session setup
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA as UInt32]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "MyQueue"))
        self.captureSession.addOutput(videoOutput)
        self.captureSession.startRunning()
    }
    
    // DES: Will display the pose skeleton results created by our model
    // PRE: poseResult must be non nil, should have exctracted pose
    // POST: Image with pose skeleton will be renderd into view.
    private func displayPoseEst(_ image: FritzVisionImage,_ poseResult: Pose<HumanSkeleton>) {
        guard let newImg = image.draw(pose: poseResult) else {
            displayInputImage(image)
            return
        }
             
        DispatchQueue.main.async {
            self.poseSuccess = self.pe.verifyPose(poseNumber: self.poseItr)
            self.previewView.image = newImg
        }
    }
    
    // DES: This will display the output image with the pose estimations if any
    // PRE: FritzVisionImage is given
    // POST: Image is rendered into view
    private func displayInputImage(_ image: FritzVisionImage) {
        guard let rotated = image.rotate() else { return }
        
        let image = UIImage(pixelBuffer: rotated)
    
        DispatchQueue.main.async {
            self.previewView.image = image
        }
    }
    
    // DES: This is the main function which handles the pose estimation of a video input,
    //      it handles the video buffer image by image, giving an estimation for each image.
    // PRE: Video feed is setup and running, bakc camera is accessable
    // POST: Image is rendered into view
    internal func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let image = FritzVisionImage(sampleBuffer: sampleBuffer, connection: connection)
        
        image.metadata = FritzVisionImageMetadata()
        image.metadata?.orientation = .leftMirrored
        
        let options = FritzVisionPoseModelOptions()
        options.minPoseThreshold = minPoseThreshold
        
        if !isActive {
            displayInputImage(image)
            return
        }
        else {
            guard let result = try? poseModel.predict(image, options: options) else {
                // If there was no pose, display original image
                displayInputImage(image)
                return
            }

            guard let pose = result.pose() else {
                displayInputImage(image)
                return
            }

            // Uncomment to use pose smoothing to smoothe output of model.
            // Will increase lag of pose a bit.
            // pose = poseSmoother.smoothe(pose)

            pe.formatKeypoints(poseResult: result)
            displayPoseEst(image, pose)
        }
    }
    
    // DES: For testing with simulator, no video feed nessary, takes one image
    // PRE: Image requested exists
    // POST: Image with pose estimation will be in view
    private func testWithImage() {
        guard let input = UIImage(named:"meHappy.jpg") else {
            print("error could not fetch image")
            return
        }
        
        let image = FritzVisionImage(image: input)

        let options = FritzVisionPoseModelOptions()
        options.minPartThreshold = minPoseThreshold
        options.minPoseThreshold = minPoseThreshold

        guard let poseResult = try? poseModel.predict(image),
        let pose = poseResult.pose()
        else {
          print("error")
          return
        }

        // Overlays pose on input image.
        let imageWithPose = image.draw(pose: pose)
        
        // render new image into view
        previewView.image = imageWithPose

        // extacts keypoints into our body vectors
        pe.formatKeypoints(poseResult: poseResult)
    }
}

// MARK: Game Loop Handlers
extension ShadowDDRVC {
    // DES: Main game loop, called by timer each second. If the pose is verified will move to next
    // PRE: At least one pose should be loaded into our PoseData object, with subseqent verification
    //      in the PoseEstimate object
    // POST: Will either load next pose or quit game.
    @objc
    private func gameLoop() {
        var readyForNext = false
        var successFlag = false
        
        if !isActive {
            return
        }
        
        if poseSuccess {
            print("success")
            readyForNext = true
            // record successful pose
            self.poseSuccessArray[poseItr] = true
            successFlag = true
        }
        else if  timeCount >= self.maxPoseTime {
            print("failure")
            readyForNext = true
        }
        
        // Move to next pose
        if readyForNext {
            if self.poseItr+1 < self.numPoses {
                self.isActive=false
                DispatchQueue.main.async {
                    self.gameTimer.invalidate()
                    self.flashFeedback(success: successFlag)
                    self.loadNextPose()
                    self.startTimer()
                }
            }
            else {
                print("game over")
                DispatchQueue.main.async {
                    self.gameTimer.invalidate()
                    self.flashFeedback(success: successFlag)
                    self.isActive = false
                    self.gameOver()
                }

            }
        }
        
        timeCount+=1
    }
    
    // DES: Loads next pose
    // PRE: poseItr be in range of our pd obj
    // POST: text and image are loaded for next pose, poseItr is on next
    private func loadNextPose() {
        self.poseItr+=1
        
        // set photo and instructions
        self.inst.text = self.pd.textAt(pos: self.poseItr)
        self.poseView.image = pd.imageAt(pos: self.poseItr)
    }
    
    // DES: Destroys captureSession and ends video, sends game results to
    // game over screen
    private func gameOver() {
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//            self.isActive = false
//            self.captureSession.stopRunning()
//            self.previewView.removeFromSuperview()
//            self.previewView = nil
//            self.captureSession = nil
            
            //Upload game result to Firebase realtime databse
            let defaults = UserDefaults.standard
            let userKey = defaults.string(forKey: "uid")
            if(userKey != nil){
                var tempScore: Double = 0
                
                for x in self.poseSuccessArray {
                    if x {
                        tempScore += 1
                    }
                }
                tempScore = tempScore/Double(self.numPoses)*100
                DbHelper.uploadGame(uid: userKey!, type: "SD", balance: String(Int(tempScore)), facial: "50", speech: "50", dexterity: "50", posture: String(Int(tempScore)))
                print("Uploaded game data");
            }
            self.performSegue(withIdentifier: "ShadowDDRGO", sender: self)
        }
    }
}
