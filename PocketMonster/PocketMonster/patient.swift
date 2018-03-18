//
//  patient.swift
//  PocketMonster
//
//  Created by Sam Liem on 17/3/2018.
//  Copyright © 2018 Dulio Denis. All rights reserved.
//

import Foundation
import UIKit

class Patient: UIImageView {
    
    let INSULIN_CONST = 10
    
    var glucose_level = 0 // (-100 - 100)
    
    var bladder = 0.5 // pee multiplier (0.5 - ?)
    var faint = 0 // faint multiplier (0 - ?)
    
    var time_since_decrease = 0 // time since last glucose decreasing activity (0 - ?)
    var hunger = 0 // hunger level (0 - 100)
    var penalties = 0 // tries or lives (0 - 3)
    
    func saveState() {
        NSUserDefaults.standardUserDefaults().setObject(glucose_level, forKey: "glucose_level")
        NSUserDefaults.standardUserDefaults().setObject(bladder, forKey: "bladder")
        NSUserDefaults.standardUserDefaults().setObject(faint, forKey: "faint")
        NSUserDefaults.standardUserDefaults().setObject(time_since_decrease, forKey: "time_since_decrease")
        NSUserDefaults.standardUserDefaults().setObject(hunger, forKey: "hunger")
        NSUserDefaults.standardUserDefaults().setObject(penalties, forKey: "penalties")
    }
    
    func loadState() {
        print(glucose_level = NSUserDefaults.standardUserDefaults().integerForKey("glucose_level"))
        glucose_level = NSUserDefaults.standardUserDefaults().integerForKey("glucose_level")
        bladder = NSUserDefaults.standardUserDefaults().doubleForKey("bladder")
        faint = NSUserDefaults.standardUserDefaults().integerForKey("faint")
        time_since_decrease = NSUserDefaults.standardUserDefaults().integerForKey("time_since_decrease")
        hunger = NSUserDefaults.standardUserDefaults().integerForKey("hunger")
        penalties = NSUserDefaults.standardUserDefaults().integerForKey("penalties")
    }
    
    func restart() {
        self.glucose_level = 0
        self.bladder = 0.5
        self.faint = 0
        self.time_since_decrease = 0
        self.hunger = 0
        self.penalties = 0
        self.playIdleAnimation()
        saveState()
    }
    
    func peeNotification() {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "onPee", object: nil))
    }
    
    func update() {
        if (time_since_decrease > 30 && abs(glucose_level) > 50 || glucose_level > 75 || glucose_level < -75) {
            penalties = penalties + 1
        }
        
        if (hunger > 75) {
            playFaintAnimation()
            penalties = penalties + 1
        }
    }
    
    func glucose(b : Int) {
        if b < 0 {
            time_since_decrease = 0
        } else if b > 0 {
            hunger = 0
        }
        glucose_level += b
    }
    
    func insulin() {
        glucose(-INSULIN_CONST)
    }
    
    func eat(intake: Int) {
        glucose(intake)
    }
    
    func exercise(intensity: Int) {
        glucose(-intensity)
        hunger += 10
        peeNotification()
    }
    
    func increment_t() {
        time_since_decrease += 1
        glucose_level += time_since_decrease
        increment_hunger()
    }
    
    func increment_hunger() {
        hunger += 1
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playIdleAnimation()
    }
    
    func playFaintAnimation() {
        self.stopAnimating()
        
        // use sleeping instead of faint
        self.image = UIImage(named: "sleeping.png")
        
//        self.animationImages = nil
//        
//        var imageArray = [UIImage]()
//        for var x = 1; x <= 1; x++ {
//            let img = UIImage(named: "faint\(x).png")
//            imageArray.append(img!)
//        }
//        
//        self.animationImages = imageArray
//        self.animationDuration = 0.8
//        self.animationRepeatCount = 1
//        self.startAnimating()
    }
    
    func playSleepingAnimation() {
        self.stopAnimating()
        self.image = UIImage(named: "sleeping1.png")
    }
    
    func playIdleAnimation() {
        self.stopAnimating()
        self.image = UIImage(named: "idle1.png")
//        self.animationImages = nil
//        
//        var imageArray = [UIImage]()
//        for var x = 1; x <= 4; x++ {
//            let img = UIImage(named: "idle\(x).png")
//            imageArray.append(img!)
//        }
//        
//        self.animationImages = imageArray
//        self.animationDuration = 0.8
//        self.animationRepeatCount = 0
//        self.startAnimating()
    }
    
    func playDeathAnimation() {
        self.stopAnimating()
        self.image = UIImage(named: "faint1.png")
//        
//        self.image = UIImage(named: "dead5.png")
//        self.animationImages = nil
//        
//        var imageArray = [UIImage]()
//        for var x = 1; x <= 5; x++ { // x <= n
//            let img = UIImage(named: "dead\(x).png")
//            imageArray.append(img!)
//        }
//        
//        self.animationImages = imageArray
//        self.animationDuration = 0.8
//        self.animationRepeatCount = 1
//        self.startAnimating()
    }
}