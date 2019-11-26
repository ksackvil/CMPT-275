//
//  ShadowDDRVC.swift
//  PARKinetics
//
//  Created by Kai Sackville-Hii on 2019-11-15.
//  Copyright © 2019 Kai Sackville-Hii. All rights reserved.
//
// Apendix A:
// below are the extracted keypoints from the given image as defined above, these
// vectors should be used for validating our positions. if you where to print foundRightLeg after
// correctly exctracting the pose then the output would look something like this...
/*
 
 [Keypoint(id: 12, position: (0.46718414098836103, 0.5267753033732557), score: 0.880, part: HumanSkeleton), Keypoint(id: 14, position: (0.46964614215064143, 0.6969218024451065), score: 0.641, part: HumanSkeleton), Keypoint(id: 16, position: (0.5093932652751759, 0.807005468914259), score: 0.536, part: HumanSkeleton)]
 
 */
// Each element in the array is a Keypoint object, each element has an id which lets you
// know which keypoint you it is, its position, and a accuracy score. The position is normalized
// from 0 to 1, with (0, 0) = (x, y) = the top left of an up oriented image.
// Use the table below to map an id with its keypoint. See this link for more info
// https://docs.fritz.ai/develop/vision/pose-estimation/ios.html
/*
 
 id | keypoint
 ---|---------
 0  | nose
 1  | left eye
 2  | right eye
 3  | left ear
 4  | right ear
 5  | left shoulder
 6  | right shoulder
 7  | left elbow
 8  | right elbow
 9  | left wrist
 10 | right wrist
 11 | left hip
 12 | right hip
 13 | left knee
 14 | right knee
 15 | left ankle
 16 | right ankle
 
 */

import UIKit
import Foundation
import Fritz

class ShadowDDRVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var previewView: UIImageView!
    var checkMark: UIImageView!
//    var overlay1: PoseOverlay!
//    var overlay2: PoseOverlay!
    var messageDisplayed = false
    var poseItr: Int = 0;
    var minPoseThreshold: Double { return 0.4 }
    private var captureSession: AVCaptureSession!    // our video session handeler
    
    // below are all the keypoints of the HumanSkeleton Object whitch we would like to
    // extract from the image. To make it easier on ourselves we divide the body into sections
    // seen below
    private let leftArmParts: [HumanSkeleton] = [.leftWrist, .leftElbow, .leftShoulder]
    private let rightArmParts: [HumanSkeleton] = [.rightWrist, .rightElbow, .rightShoulder]
    private let leftLegParts: [HumanSkeleton] = [.leftAnkle, .leftKnee, .leftHip]
    private let rightLegParts: [HumanSkeleton] = [.rightAnkle, .rightKnee, .rightHip]
    private let faceParts: [HumanSkeleton] = [.rightEar, .leftEar, .rightEye, .leftEye, .nose]
    
    // See Apendix A
    private var foundLeftArm: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
    private var foundRightArm: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
    private var foundLeftLeg: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
    private var foundRightLeg: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
    private var foundFace: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
    
    lazy var poseModel = FritzVisionHumanPoseModelFast()
    lazy var poseSmoother = PoseSmoother<OneEuroPointFilter, HumanSkeleton>()
    

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
        
        // previewView which hosues the pose estimations
        previewView = UIImageView(frame: view.bounds)
        previewView.contentMode = .scaleAspectFill
        view.addSubview(previewView)
        
        // View for checkmark
        checkMark = UIImageView(frame: view.bounds)
        checkMark.image = UIImage(named:"correct.png")
        checkMark.contentMode = .center
        checkMark.alpha = 0
        view.addSubview(checkMark)
        view.bringSubviewToFront(checkMark) // ensures view is loaded in front of others
        
        // our video session handeler
        captureSession = {
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
    
    // DES: Sets up our view with subviews
    override func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      previewView.frame = view.bounds
    }

    // DES: handle memory warnings
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helper Fuctions
    // DES: takes the keypoints and formats into our body section vectors
    // PRE: system was able to estimate pose in poseResult
    // POST: each body vector will be updated accordingly
    func formatKeypoints(poseResult: FritzVisionPoseResult<HumanSkeleton>) {
        var tempLeftArm: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
        var tempRightArm: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
        var tempLeftLeg: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
        var tempRightLeg: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
        var tempFace: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
        
        // attempt to decode results
        guard let poseEstimate = poseResult.pose() else {
            print("error could not extract pose from image")
            return
        }
        
        for keypoint in poseEstimate.keypoints {
            if leftArmParts.contains(keypoint.part) {
                tempLeftArm.append(keypoint)
            }
            else if rightArmParts.contains(keypoint.part) {
                tempRightArm.append(keypoint)
            }
            else if leftLegParts.contains(keypoint.part) {
                tempLeftLeg.append(keypoint)
            }
            else if rightLegParts.contains(keypoint.part) {
                tempRightLeg.append(keypoint)
            }
            else if faceParts.contains(keypoint.part) {
                tempFace.append(keypoint)
            }
        }
        
        foundLeftArm = tempLeftArm
        foundRightArm = tempRightArm
        foundLeftLeg = tempLeftLeg
        foundRightLeg = tempRightLeg
        foundFace = tempFace
    }
    
    // DES: Handles animation for flashing checkmark on successful pose
    func flashCheckMark() {
        UIView.animate(withDuration: 1, delay: 0.0 , animations: {
            self.checkMark.alpha = 1
        }, completion: {_ in
            UIView.animate(withDuration: 1.2, delay: 0.0 , animations: {
                  self.checkMark.alpha = 0
            })

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.messageDisplayed = false
            }
        })
    }
    
    // DES: main function for verifiying our expected poses
    // PRE: A set of poses must be predefined, each case will have an id (0 - inf) this function
    //      will verifiy based on the current poseItr (id).
    // POST: if pose mathces current expected pose, func returns true
    func verifyPose() -> Bool {
        var verified = false
        
        switch self.poseItr {
        case 0:
            let rWristAboveShoulder = abs(Float(foundLeftArm[2].position.y) - Float(foundLeftArm[0].position.y)) < 0.1
            let rWristLeftOfShoulder = Float(foundLeftArm[2].position.x) > Float(foundLeftArm[0].position.x)
            
            verified = rWristAboveShoulder && rWristLeftOfShoulder && messageDisplayed == false
            
        default:
            verified = false
        }
        
        return(verified)
    }
    
    // MARK: Output Video Handlers
    // DES: Will display the pose skeleton results created by our model
    // PRE: poseResult must be non nil, should have exctracted pose
    // POST: Image with pose skeleton will be renderd into view.
    func displayPoseEst(_ image: FritzVisionImage,_ poseResult: Pose<HumanSkeleton>) {
        let success = verifyPose()
        
        guard let newImg = image.draw(pose: poseResult) else {
            displayInputImage(image)
            return
        }
             
        DispatchQueue.main.async {
            self.previewView.image = newImg
            
            if success {
                self.messageDisplayed = true
                self.flashCheckMark()
            }
//            self.overlay1.reloadData()
//            self.overlay2.reloadData()
        }
    }
    
    // DES: This will display the output image with the pose estimations if any
    // PRE: FritzVisionImage is given
    // POST: Image is rendered into view
    func displayInputImage(_ image: FritzVisionImage) {
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
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let image = FritzVisionImage(sampleBuffer: sampleBuffer, connection: connection)
        
        image.metadata = FritzVisionImageMetadata()
        image.metadata?.orientation = .leftMirrored
        
        let options = FritzVisionPoseModelOptions()
        options.minPoseThreshold = minPoseThreshold

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

        formatKeypoints(poseResult: result)
        displayPoseEst(image, pose)
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
        formatKeypoints(poseResult: poseResult)
    }
    
}
