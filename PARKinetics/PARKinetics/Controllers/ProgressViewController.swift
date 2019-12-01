//
//  ProgressViewController.swift
//
//  Created by TANKER on 2019-10-04.
//  Copyright © 2019 TANKER. All rights reserved.
//
//  Description:
//      View controller for Progress view page
//
//  Contributors:
//      Kai Sackville-Hii
//          - File creation
//          - radar chart
//          - user progress view
//

import Foundation
import UIKit
import Charts

class ProgressViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var userProgress: UIView! // Progress bar for user
    @IBOutlet weak var userProgLabel: UILabel! // text for progress bar
    @IBOutlet weak var legendSet2: UIView! // legend for set 2
    @IBOutlet weak var legendSet1: UIView! // legend for set 1
    @IBOutlet weak var radarChart: RadarChartView! // radial chart view
    
    // MARK: Vars
    let userProgressCornerRadius: CGFloat = 100 // radius of view
    let userProgressLayer: CAShapeLayer = CAShapeLayer() // outter layer
    let userProgressInnerLayer: CAShapeLayer = CAShapeLayer() // inner layer
    let baseColor = UIColor(red: 112, green: 128, blue: 144) // base color
    var userProgressBorderLayer: CAShapeLayer = CAShapeLayer() // border of progress view
    let labels = ["Posture", "Balance", "Speech", "Dexterity", "Facial"] // 5 used skills
    
    // MARK: Overrides
    // DES: renders when the view loads
    // PRE: view has loaded , UI elements exist in main storyboard and are connected
    //      to this class
    // POST: UI objects for radial chart and user progress in view
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        let screenSize: CGRect = UIScreen.main.bounds
        let scaleX = screenSize.width / 768//768 is ipadPro screen width
        let scaleY = screenSize.height / 1024 //1024 is ipadPro screen height
        self.view.transform = CGAffineTransform.identity.scaledBy(x: scaleX, y: scaleY)
                
        //draw the progress layer and update the bar
        drawUserProgressLayer()
        updateUserProgress(inc: 200.0)
        userProgLabel.layer.zPosition = 1
        
        // setup radial chart
        radarChart.chartDescription?.enabled = false
        radarChart.webLineWidth = 2
        radarChart.innerWebLineWidth = 2
        radarChart.webColor = baseColor
        radarChart.innerWebColor = baseColor
        radarChart.webAlpha = 1
        radarChart.legend.enabled = false
        
        // radial chart xaxis properties
        let xAxis = radarChart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 22, weight: .regular)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.drawLabelsEnabled = true
        xAxis.valueFormatter = RadarChartXValueFormatter(withLabels: labels)
        xAxis.labelTextColor = .white
        
        // radial chart yaxis properties
        let yAxis = radarChart.yAxis
        yAxis.labelFont = .systemFont(ofSize: 22, weight: .regular)
        yAxis.labelCount = 3
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 80
        yAxis.drawLabelsEnabled = false
        
        // legends for each set setuo
        legendSet1.layer.cornerRadius = 10
        legendSet1.clipsToBounds = true
        legendSet1.tag = 1
        legendSet2.layer.cornerRadius = 10
        legendSet2.clipsToBounds = true
        legendSet2.tag = 1

        // render chart and animate
        radarChartUpdate()
        radarChart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    // DES: renders the user progress bar
    // PRE: views exist and are connected
    // POST: progress bar is in view and updated with current progress
    private func drawUserProgressLayer() {
        // create a path for outer layer
        let bezierPath = UIBezierPath(roundedRect: userProgress.bounds, cornerRadius: userProgressCornerRadius)
        bezierPath.close()
        
        // update outer layer with path and color
        userProgressBorderLayer.path = bezierPath.cgPath
        userProgressBorderLayer.fillColor = UIColor.white.cgColor
        userProgressBorderLayer.strokeEnd = 0
        
        // create a path for inner layer
        let innerBezierPath = UIBezierPath(roundedRect: CGRect( x: 2, y: 2, width: userProgress.bounds.width-4, height: userProgress.bounds.height-4), cornerRadius: userProgressCornerRadius)
        innerBezierPath.close()
        
        // update inner layer
        userProgressInnerLayer.path = innerBezierPath.cgPath
        userProgressInnerLayer.fillColor = UIColor(red: 42, green: 44, blue: 46).cgColor
        userProgressInnerLayer.strokeEnd = 0
        
        // add layers to view
        userProgress.layer.addSublayer(userProgressBorderLayer)
        userProgress.layer.addSublayer(userProgressInnerLayer)
    }
    
    // DES: renders the user progress bar
    // PRE: views exist and are connected
    // POST: progress bar is in view and updated with current progress
    public func updateUserProgress(inc: CGFloat) {
        if (inc <= userProgress.bounds.width - 10) {
            userProgressLayer.removeFromSuperlayer()
            
            let bezierPathProg = UIBezierPath(roundedRect: CGRect( x: 1.4, y: 2, width: inc, height: userProgress.bounds.height-4), cornerRadius: userProgressCornerRadius)
            bezierPathProg.close()
            userProgressLayer.path = bezierPathProg.cgPath
            userProgressLayer.fillColor = UIColor(red: 255, green: 99, blue: 119).cgColor
            userProgress.layer.addSublayer(userProgressLayer)
            
        }
    }
    
    // DES: convience call to update chart
    private func radarChartUpdate() {
        //Retrieve data from database
        let defaults = UserDefaults.standard
        let userKey = defaults.string(forKey: "uid")
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        var currentWeekGames : [[String : Any]] = []
        var lastWeekGames : [[String : Any]] = []
        var currentWeekAvg : [String : Int] = ["balance":0,"facial":0,"speech":0,"dexterity":0,"posture":0]
        var lastWeekAvg : [String : Int] = ["balance":0,"facial":0,"speech":0,"dexterity":0,"posture":0]
        if(userKey != nil){
            DbHelper.retrieveAllGames(uid: userKey!, closure: {
                (games) in
                for game in games {
                    if(game["time"] as! Int == weekOfYear){
                        currentWeekGames.append(game)
                    }else if(game["time"] as! Int == weekOfYear - 1){
                        lastWeekGames.append(game)
                    }
                }
                for game in currentWeekGames{
                    currentWeekAvg["balance"]! += (game["balance"] as! NSString).integerValue
                    currentWeekAvg["facial"]! += (game["facial"] as! NSString).integerValue
                    currentWeekAvg["speech"]! += (game["speech"] as! NSString).integerValue
                    currentWeekAvg["dexterity"]! += (game["dexterity"] as! NSString).integerValue
                    currentWeekAvg["posture"]! += (game["posture"] as! NSString).integerValue
                }
                //Get average game vaule of current week
                if(currentWeekGames.count > 0){
                    currentWeekAvg["balance"]! /= currentWeekGames.count
                    currentWeekAvg["facial"]! /= currentWeekGames.count
                    currentWeekAvg["speech"]! /= currentWeekGames.count
                    currentWeekAvg["dexterity"]! /= currentWeekGames.count
                    currentWeekAvg["posture"]! /= currentWeekGames.count
                }
                
                for game in lastWeekGames{
                    lastWeekAvg["balance"]! += (game["balance"] as! NSString).integerValue
                    lastWeekAvg["facial"]! += (game["facial"] as! NSString).integerValue
                    lastWeekAvg["speech"]! += (game["speech"] as! NSString).integerValue
                    lastWeekAvg["dexterity"]! += (game["dexterity"] as! NSString).integerValue
                    lastWeekAvg["posture"]! += (game["posture"] as! NSString).integerValue
                }
                //Get average game vaule of last week
                if(lastWeekGames.count > 0){
                    lastWeekAvg["balance"]! /= lastWeekGames.count
                    lastWeekAvg["facial"]! /= lastWeekGames.count
                    lastWeekAvg["speech"]! /= lastWeekGames.count
                    lastWeekAvg["dexterity"]! /= lastWeekGames.count
                    lastWeekAvg["posture"]! /= lastWeekGames.count
                }
                self.setChartData(currentWeekAvg: currentWeekAvg, lastWeekAvg: lastWeekAvg)
            })
        }
    }
    
    // DES: convience call to update chart
    // PRE: UI elements exists
    // POST: Two sets of data will be added to chart
    func setChartData(currentWeekAvg: [String:Int], lastWeekAvg: [String:Int]) {
//        let mult: UInt32 = 80
//        let min: UInt32 = 10
//        let cnt = 5
//
//        let block: (Int) -> RadarChartDataEntry = { _ in return RadarChartDataEntry(value: Double(arc4random_uniform(mult) + min))}
//        let entries1 = (0..<cnt).map(block)
//        let entries2 = (0..<cnt).map(block)
        
        //Set data for entries
        let entries1 : [RadarChartDataEntry] = [RadarChartDataEntry(value: Double(lastWeekAvg["posture"]!)), RadarChartDataEntry(value: Double(lastWeekAvg["balance"]!)), RadarChartDataEntry(value: Double(lastWeekAvg["speech"]!)), RadarChartDataEntry(value: Double(lastWeekAvg["dexterity"]!)), RadarChartDataEntry(value: Double(lastWeekAvg["facial"]!))]
        let entries2 : [RadarChartDataEntry] = [RadarChartDataEntry(value: Double(currentWeekAvg["posture"]!)), RadarChartDataEntry(value: Double(currentWeekAvg["balance"]!)), RadarChartDataEntry(value: Double(currentWeekAvg["speech"]!)), RadarChartDataEntry(value: Double(currentWeekAvg["dexterity"]!)), RadarChartDataEntry(value: Double(currentWeekAvg["facial"]!))]
//        let entries1 : [RadarChartDataEntry] = [RadarChartDataEntry(value: lastWeekAvg["posture"]! as! Double), RadarChartDataEntry(value: lastWeekAvg["balance"]! as! Double), RadarChartDataEntry(value: lastWeekAvg["speech"]! as! Double), RadarChartDataEntry(value: lastWeekAvg["dexterity"]! as! Double), RadarChartDataEntry(value: lastWeekAvg["facial"]! as! Double)]
//        let entries2 : [RadarChartDataEntry] = [RadarChartDataEntry(value: currentWeekAvg["posture"]! as! Double), RadarChartDataEntry(value: currentWeekAvg["balance"]! as! Double), RadarChartDataEntry(value: currentWeekAvg["speech"]! as! Double), RadarChartDataEntry(value: currentWeekAvg["dexterity"]! as! Double), RadarChartDataEntry(value: currentWeekAvg["facial"]! as! Double)]
        
        // setup sets
        let set1 = RadarChartDataSet(entries: entries1, label: "Last Week")
        set1.setColor(UIColor(red: 122, green: 124, blue: 129))
        set1.fillColor = UIColor(red: 122, green: 124, blue: 129)
        set1.drawFilledEnabled = true
        set1.fillAlpha = 0.7
        set1.lineWidth = 2
        set1.drawHighlightCircleEnabled = true
        set1.setDrawHighlightIndicators(false)
        
        let set2 = RadarChartDataSet(entries: entries2, label: "This Week")
        set2.setColor(UIColor(red: 255, green: 99, blue: 119))
        set2.fillColor = UIColor(red: 255, green: 99, blue: 119)
        set2.drawFilledEnabled = true
        set2.fillAlpha = 0.7
        set2.lineWidth = 2
        set2.drawHighlightCircleEnabled = true
        set2.setDrawHighlightIndicators(false)
        
        // add sets data
        let data = RadarChartData(dataSets: [set1, set2])
        data.setValueFont(.systemFont(ofSize: 8, weight: .light))
        data.setDrawValues(false)
        data.setValueTextColor(.white)
        radarChart.data = data
    }
    
    // DES: handle swipe left
    // PRE: Swipe controller exists
    // POST: will segue back to home view with animation
    @IBAction func swipeHandler(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

// Helper class for setting chart data
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
