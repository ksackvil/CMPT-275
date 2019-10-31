//
//  ProgressViewController.swift
//  
//
//  Created by Kai Sackville-Hii on 2019-10-28.
//

import Foundation
import UIKit
import Charts

class ProgressViewController: UIViewController {
    
    @IBOutlet weak var userProgress: UIView!
    @IBOutlet weak var userProgLabel: UILabel!
    @IBOutlet weak var radarChart: RadarChartView!
    
    let userProgressCornerRadius: CGFloat = 100
    let userProgressLayer: CAShapeLayer = CAShapeLayer()
    let userProgressInnerLayer: CAShapeLayer = CAShapeLayer()
    
    var userProgressBorderLayer: CAShapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        drawUserProgressLayer()
        updateUserProgress(inc: 80.0)
        userProgLabel.layer.zPosition = 1
        
        radarChartUpdate();
    }
    
    private func drawUserProgressLayer() {
        let bezierPath = UIBezierPath(roundedRect: userProgress.bounds, cornerRadius: userProgressCornerRadius)

        bezierPath.close()
        userProgressBorderLayer.path = bezierPath.cgPath
        userProgressBorderLayer.fillColor = UIColor(red: 173, green: 193, blue: 219).cgColor
        userProgressBorderLayer.strokeEnd = 0

        let innerBezierPath = UIBezierPath(roundedRect: CGRect( x: 5, y: 5, width: userProgress.bounds.width-10, height: userProgress.bounds.height-10), cornerRadius: userProgressCornerRadius)

        innerBezierPath.close()
        userProgressInnerLayer.path = innerBezierPath.cgPath
        userProgressInnerLayer.fillColor = UIColor.white.cgColor
        userProgressInnerLayer.strokeEnd = 0

        userProgress.layer.addSublayer(userProgressBorderLayer)
        userProgress.layer.addSublayer(userProgressInnerLayer)
    }

    private func updateUserProgress(inc: CGFloat) {

        if (inc <= userProgress.bounds.width - 10) {
            userProgressLayer.removeFromSuperlayer()

            let bezierPathProg = UIBezierPath(roundedRect: CGRect( x: 4, y: 5, width: inc, height: userProgress.bounds.height-10), cornerRadius: userProgressCornerRadius)
            bezierPathProg.close()
            userProgressLayer.path = bezierPathProg.cgPath
            userProgressLayer.fillColor = UIColor(red: 255, green: 141, blue: 156).cgColor
            userProgress.layer.addSublayer(userProgressLayer)

        }
    }
    
    private func radarChartUpdate() {
        let entry1 = RadarChartDataEntry(value: Double(50))
        let entry2 = PieChartDataEntry(value: Double(50))

        let dataSet = RadarChartDataSet(entries: [entry1, entry2], label: "Widget Types")
        let data = RadarChartData(dataSet: dataSet)
        radarChart.data = data
        radarChart.chartDescription?.text = "Share of Widgets by Type"
        
        //All other additions to this function will go here
        
        //This must stay at end of function
        radarChart.notifyDataSetChanged()
    }
    
    @IBAction func swipeHandler(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

//extension UIColor {
//    convenience init(red: Int, green: Int, blue: Int) {
//        assert(red >= 0 && red <= 255, "Invalid red component")
//        assert(green >= 0 && green <= 255, "Invalid green component")
//        assert(blue >= 0 && blue <= 255, "Invalid blue component")
//        
//        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
//    }
//    
//    convenience init(rgb: Int) {
//        self.init(
//            red: (rgb >> 16) & 0xFF,
//            green: (rgb >> 8) & 0xFF,
//            blue: rgb & 0xFF
//        )
//    }
//}
