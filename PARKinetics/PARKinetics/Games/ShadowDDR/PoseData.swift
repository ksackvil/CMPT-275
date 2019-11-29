//
//  PoseData.swift
//  PARKinetics
//
//  Created by Kai Sackville-Hii on 2019-11-25.
//  Copyright © 2019 Kai Sackville-Hii. All rights reserved.
//

import Foundation
import UIKit

class PoseData {
    private let text: [String] = [
        "Stand with your arms by your side",
        "Raise your hands to shoulder height",
        "Lung left"
    ]
    private let image: [UIImage] = [
        UIImage(named: "standPose.png")!,
        UIImage(named: "starPose.png")!,
        UIImage(named: "leftLungePose.png")!
    ]
    
    func textAt(pos: Int) -> String {
        return self.text[pos]
    }
    
    func imageAt(pos: Int) -> UIImage {
        return image[pos]
    }
    
    func size() -> Int{
        return text.count
    }
}
