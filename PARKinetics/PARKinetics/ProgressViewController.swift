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
    
//    @IBOutlet weak var userProgress: UIView!
//    @IBOutlet weak var userProgLabel: UILabel!
    @IBOutlet weak var radarChart: RadarChartView!
    
    let userProgressCornerRadius: CGFloat = 100
    let userProgressLayer: CAShapeLayer = CAShapeLayer()
    let userProgressInnerLayer: CAShapeLayer = CAShapeLayer()
    
    let baseColor = UIColor(red: 112, green: 128, blue: 144)
    
    var userProgressBorderLayer: CAShapeLayer = CAShapeLayer()

    let labels = ["Posture", "Balance", "Speech", "Dexterity", "Facial"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
//        drawUserProgressLayer()
//        userProgLabel.layer.zPosition = 1
//        updateUserProgress(inc: 80.0)
        
        radarChart.chartDescription?.enabled = false
        radarChart.webLineWidth = 2
        radarChart.innerWebLineWidth = 2
        radarChart.webColor = baseColor
        radarChart.innerWebColor = baseColor
        radarChart.webAlpha = 1
        radarChart.legend.enabled = false
        
        let xAxis = radarChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 22, weight: .regular)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.drawLabelsEnabled = true
        xAxis.valueFormatter = RadarChartXValueFormatter(withLabels: labels)
        xAxis.labelTextColor = baseColor
        
        let yAxis = radarChart.yAxis
        yAxis.labelFont = .systemFont(ofSize: 22, weight: .regular)
        yAxis.labelCount = 3
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 80
        yAxis.drawLabelsEnabled = false
        
//        let l = radarChart.legend
//        l.horizontalAlignment = .center
//        l.verticalAlignment = .top
//        l.orientation = .horizontal
//        l.drawInside = false
//        l.font = .systemFont(ofSize: 22, weight: .regular)
//        l.xEntrySpace = 10
//        l.yEntrySpace = 10
//        l.textColor = baseColor
        
        radarChartUpdate()
        radarChart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
//    private func drawUserProgressLayer() {
//        let bezierPath = UIBezierPath(roundedRect: userProgress.bounds, cornerRadius: userProgressCornerRadius)
//
//        bezierPath.close()
//        userProgressBorderLayer.path = bezierPath.cgPath
//        userProgressBorderLayer.fillColor = baseColor.cgColor
//        userProgressBorderLayer.strokeEnd = 0
//
//        let innerBezierPath = UIBezierPath(roundedRect: CGRect( x: 5, y: 5, width: userProgress.bounds.width-10, height: userProgress.bounds.height-10), cornerRadius: userProgressCornerRadius)
//
//        innerBezierPath.close()
//        userProgressInnerLayer.path = innerBezierPath.cgPath
//        userProgressInnerLayer.fillColor = UIColor.white.cgColor
//        userProgressInnerLayer.strokeEnd = 0
//
//        userProgress.layer.addSublayer(userProgressBorderLayer)
//        userProgress.layer.addSublayer(userProgressInnerLayer)
//    }
//
//    private func updateUserProgress(inc: CGFloat) {
//
//        if (inc <= userProgress.bounds.width - 10) {
//            userProgressLayer.removeFromSuperlayer()
//
//            let bezierPathProg = UIBezierPath(roundedRect: CGRect( x: 4, y: 5, width: inc, height: userProgress.bounds.height-10), cornerRadius: userProgressCornerRadius)
//            bezierPathProg.close()
//            userProgressLayer.path = bezierPathProg.cgPath
//            userProgressLayer.fillColor = UIColor(red: 255, green: 141, blue: 156).cgColor
//            userProgress.layer.addSublayer(userProgressLayer)
//
//        }
//    }
    
    private func radarChartUpdate() {
        self.setChartData()
    }
    
    func setChartData() {
        let mult: UInt32 = 80
        let min: UInt32 = 20
        let cnt = 5
        
        let block: (Int) -> RadarChartDataEntry = { _ in return RadarChartDataEntry(value: Double(arc4random_uniform(mult) + min))}
        let entries1 = (0..<cnt).map(block)
        let entries2 = (0..<cnt).map(block)
        
        let set1 = RadarChartDataSet(entries: entries1, label: "Last Week")
        set1.setColor(UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1))
        set1.fillColor = UIColor(red: 103/255, green: 110/255, blue: 129/255, alpha: 1)
        set1.drawFilledEnabled = true
        set1.fillAlpha = 0.7
        set1.lineWidth = 2
        set1.drawHighlightCircleEnabled = true
        set1.setDrawHighlightIndicators(false)
        
        let set2 = RadarChartDataSet(entries: entries2, label: "This Week")
        set2.setColor(UIColor(red: 121/255, green: 162/255, blue: 175/255, alpha: 1))
        set2.fillColor = UIColor(red: 121/255, green: 162/255, blue: 175/255, alpha: 1)
        set2.drawFilledEnabled = true
        set2.fillAlpha = 0.7
        set2.lineWidth = 2
        set2.drawHighlightCircleEnabled = true
        set2.setDrawHighlightIndicators(false)
        
        let data = RadarChartData(dataSets: [set1, set2])
        data.setValueFont(.systemFont(ofSize: 8, weight: .light))
        data.setDrawValues(false)
        data.setValueTextColor(.white)
        
        radarChart.data = data
    }
    
    @IBAction func swipeHandler(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

class RadarChartXValueFormatter: NSObject, IAxisValueFormatter {
    
    init(withLabels labels: String...) {
        self.labels = labels
        super.init()
    }
    
    init(withLabels labels: [String]) {
        self.labels = labels
        super.init()
    }
    
    var labels: [String]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let index = Int(value)
        return labels.indices ~= index ? labels[index] : ""
    }
    
}
