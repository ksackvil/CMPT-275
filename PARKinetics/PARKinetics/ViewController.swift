//
//  ViewController.swift
//  PARKinetics
//
//  Created by TANKER on 2019-10-04.
//  Copyright © 2019 TANKER. All rights reserved.
//
//  Description:
//      This file is the view controller for the Home screen. This is the root
//      controller for the PARKinetics project.

//  Contributors:
//      Kai Sackville-Hii
//          - File creation
//          - view setup and animations
//          - unwindToViewController() segue
//          - UIColor extension
//
//      DELETEME

import UIKit

class ViewController: UIViewController {
    // MARK: Vars
    let corrnerRad: CGFloat = 10
    
    // MARK: Outlets
    @IBOutlet weak var fingerTwister: UIButton! // finger twister button
    @IBOutlet weak var fingerTwisterLabel: UILabel! // finger twister button text
    @IBOutlet weak var adventureStory: UIButton! // adventure story button
    @IBOutlet weak var adventureStoryLabel: UILabel! // adventure story button text
    @IBOutlet weak var shadowDdr: UIButton! // shadow ddr button
    @IBOutlet weak var shadowDdrLabel: UILabel! // shadow ddr button text
    @IBOutlet weak var toolBar: UIBarButtonItem! // tool bar indicators
    @IBOutlet weak var mainTitle: UILabel! // Title "PARKinetics
    @IBOutlet weak var adventureStoryView: UIView! // view for adventure story
    @IBOutlet weak var fingerTwisterView: UIView! // view for finger twister
    @IBOutlet weak var shadowDdrView: UIView! // view for shadow ddr

    // MARK: Overides
    // DES: called before view will appear
    // PRE: animated is defined, navigation controller exists
    // POST: the top navigation bar will be hidden, and toolbar will be visable
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    // DES: renders when the view loads
    // PRE: view has loaded , UI elements exist in main storyboard and are connected
    //      to this class
    // POST: Initial view will look like splash screen, then animation occurs
    //       to render buttons and title into view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Round button corners for each of the game buttons
        fingerTwister.layer.cornerRadius = corrnerRad   // set a radius for corners
        fingerTwister.clipsToBounds = true              // set button corners to be cliped
        fingerTwister.tag = 1                           // assign unique tag for button
        
        // Repeat above process for the other buttons
        adventureStory.layer.cornerRadius = corrnerRad
        adventureStory.clipsToBounds = true
        adventureStory.tag = 2
        shadowDdr.layer.cornerRadius = corrnerRad
        shadowDdr.clipsToBounds = true
        shadowDdr.tag = 3
        
        // Set initial state of buttons to hidden
        adventureStoryView.isHidden = true
        fingerTwisterView.isHidden = true
        shadowDdrView.isHidden = true
        
        // main animation handler
        animateHandler()
    }
    
    // DES: Handlers initial animations
    // PRE: view has loaded , UI elements exist in main storyboard and are connected
    //      to this class
    // POST: mainTitle animates up to top position from splash, buttons cross desolve into view
    func animateHandler() {
        // handle multiple animations at once
        UIView.animateKeyframes(withDuration: 1.0, delay: 0.3, options: [], animations: {
            // enlarge main title text to match splash screen size
            self.mainTitle.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            
            // Move main title up, will automatically shrink to size
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6, animations: {
                self.mainTitle.transform = CGAffineTransform(translationX: 0, y: -230)
            })
        }, completion: {_ in
            // cross desolve into view the three buttons
            UIView.transition(with: self.adventureStoryView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.adventureStoryView.isHidden = false
            }, completion: nil)
            UIView.transition(with: self.fingerTwisterView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.fingerTwisterView.isHidden = false
            }, completion: nil)
            UIView.transition(with: self.shadowDdrView, duration: 0.5, options: .transitionCrossDissolve, animations: {
                self.shadowDdrView.isHidden = false
            }, completion: nil)
        })
    }
    
    // DES: Handles unwind to this view
    // PRE: Called from child view controller
    // POST: current view object will be pushed into view
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
        // custom unwind handler empty for now
    }
    
}

// MARK: Helpers
// DES: conveience helper for UIColor
// PRE: Pass through rgb or hex value of a color
// POST: returns swift UIColor object
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
