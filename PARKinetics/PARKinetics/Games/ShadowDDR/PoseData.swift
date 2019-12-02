//
//  PoseData.swift
//  PARKinetics
//
//  Created by Kai Sackville-Hii on 2019-11-25.
//  Copyright © 2019 Kai Sackville-Hii. All rights reserved.
//
//  Description:
//      This file loads the each pose text and image for shadow ddr
//
//  Contributors:
//      Kai Sackville-Hii
//          - Poses added
//          - helper functions

import Foundation
import UIKit

class PoseData {
    // helper labels for poses
    private let text: [String] = [
        "Stand with your arms by your side",
        "Raise your hands to shoulder height",
        "Lunge right",
        "Lunge left",
        
    ]
    
    // images for poses
    private let image: [UIImage] = [
        UIImage(named: "standPose.png")!,
        UIImage(named: "starPose.png")!,
        UIImage(named: "leftLungePose.png")!,
        UIImage(named: "rightLungePose.png")!
    ]
    
    // DES: returns pose text
    func textAt(pos: Int) -> String {
        return self.text[pos]
    }
    
    // DES: returns image pose
    func imageAt(pos: Int) -> UIImage {
        return image[pos]
    }
    
    // DES: returns number of poses
    func size() -> Int{
        return text.count
    }
}
