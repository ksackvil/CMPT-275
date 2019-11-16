//
//  ShadowDDRVC.swift
//  PARKinetics
//
//  Created by Kai Sackville-Hii on 2019-11-15.
//  Copyright © 2019 Kai Sackville-Hii. All rights reserved.
//

import UIKit
import Foundation
import Fritz

class ShadowDDRVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var previewView: UIImageView!
    
    // below are all the keypoints of the HumanSkeleton Object whitch we would like to
    // extract from the image. To make it easier on ourselves we divide the body into sections
    // seen below
    private let leftArmParts: [HumanSkeleton] = [.leftWrist, .leftElbow, .leftShoulder]
    private let rightArmParts: [HumanSkeleton] = [.rightWrist, .rightElbow, .rightShoulder]
    private let leftLegParts: [HumanSkeleton] = [.leftAnkle, .leftKnee, .leftHip]
    private let rightLegParts: [HumanSkeleton] = [.rightAnkle, .rightKnee, .rightHip]
    private let faceParts: [HumanSkeleton] = [.rightEar, .leftEar, .rightEye, .leftEye, .nose]
    
    // Below are the extracted keypoints from the given image as defined above, these
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
    private var foundLeftArm: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
    private var foundRightArm: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
    private var foundLeftLeg: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
    private var foundRightLeg: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
    private var foundFace: [Keypoint] = [] as! [Keypoint<HumanSkeleton>]
    
    lazy var poseModel = FritzVisionHumanPoseModelFast()
    lazy var poseSmoother = PoseSmoother<OneEuroPointFilter, HumanSkeleton>()

    // our video session handeler
    private lazy var captureSession: AVCaptureSession = {
      let session = AVCaptureSession()

      guard
        let backCamera = AVCaptureDevice.default(
            .builtInWideAngleCamera,
          for: .video,
          position: .back),
        let input = try? AVCaptureDeviceInput(device: backCamera)
        else { return session }
      session.addInput(input)

      session.sessionPreset = .photo
      return session
    }()

    var minPoseThreshold: Double { return 0.4 }

    // DES: Hides toolbar
    // PRE: View loaded from main menu segue
    // POST: Toolbar hidden
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add preview View as a subview
        previewView = UIImageView(frame: view.bounds)
        previewView.contentMode = .scaleAspectFill
        view.addSubview(previewView)

        // !*!* comment out this line when using videofeed
        testWithImage()
        
        // !*!* uncomment below to enable video feed
        /*
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA as UInt32]
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "MyQueue"))
        self.captureSession.addOutput(videoOutput)
        self.captureSession.startRunning()
        */
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
    
    // DES: takes the keypoints and formats into our body section vectors
    func formatKeypoints(poseResult: FritzVisionPoseResult<HumanSkeleton>) {
        // attempt to decode results
        guard let poseEstimate = poseResult.pose() else {
            print("error could not extract pose from image")
            return
        }
        
        for keypoint in poseEstimate.keypoints {
            if leftArmParts.contains(keypoint.part) {
              foundLeftArm.append(keypoint)
            }
            else if rightArmParts.contains(keypoint.part) {
              foundRightArm.append(keypoint)
            }
            else if leftLegParts.contains(keypoint.part) {
                foundLeftLeg.append(keypoint)
            }
            else if rightLegParts.contains(keypoint.part) {
                foundRightLeg.append(keypoint)
            }
            else if faceParts.contains(keypoint.part) {
                foundFace.append(keypoint)
            }
        }
        print("face")
        print(foundFace)
        print("leftArm")
        print(foundLeftArm)
        print("rightArm")
        print(foundRightArm)
        print("leftLeg")
        print(foundLeftLeg)
        print("rightLeg")
        print(foundRightLeg)
    }
    
    // DES: This is the main function which handles the pose estimation of a video input,
    //      it handles the video buffer image by image, giving an estimation for each image.
    // PRE: Video feed is setup and running, bakc camera is accessable
    // POST: Image is rendered into view
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let image = FritzVisionImage(sampleBuffer: sampleBuffer, connection: connection)
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

        guard let poseResult = image.draw(pose: pose) else {
            displayInputImage(image)
            return
        }

        formatKeypoints(poseResult: result)
        
        DispatchQueue.main.async {
        self.previewView.image = poseResult
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
        formatKeypoints(poseResult: poseResult)
    }
    
}
