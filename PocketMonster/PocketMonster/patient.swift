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
    
    var bladder = 100
    var faint = 100 // faint multiplier (0 - ?)
    
    var time_since_decrease = 0 // time since last glucose decreasing activity (0 - ?)
    var hunger = 0 // hunger level (0 - 100)
    var penalties = 0 // tries or lives (0 - 3)
    
    var isFainted = false
    
    func saveState() {
        NSUserDefaults.standardUserDefaults().setObject(glucose_level, forKey: "glucose_level")
        NSUserDefaults.standardUserDefaults().setObject(bladder, forKey: "bladder")
        NSUserDefaults.standardUserDefaults().setObject(faint, forKey: "faint")
        NSUserDefaults.standardUserDefaults().setObject(isFainted, forKey: "isFainted")
        NSUserDefaults.standardUserDefaults().setObject(time_since_decrease, forKey: "time_since_decrease")
        NSUserDefaults.standardUserDefaults().setObject(hunger, forKey: "hunger")
        NSUserDefaults.standardUserDefaults().setObject(penalties, forKey: "penalties")
    }
    
    func loadState() {
        glucose_level = NSUserDefaults.standardUserDefaults().integerForKey("glucose_level")
        bladder = NSUserDefaults.standardUserDefaults().integerForKey("bladder")
        faint = NSUserDefaults.standardUserDefaults().integerForKey("faint")
        isFainted = NSUserDefaults.standardUserDefaults().boolForKey("isFainted")
        time_since_decrease = NSUserDefaults.standardUserDefaults().integerForKey("time_since_decrease")
        hunger = NSUserDefaults.standardUserDefaults().integerForKey("hunger")
        penalties = NSUserDefaults.standardUserDefaults().integerForKey("penalties")
    }
    
    func restart() {
        glucose_level = 0
        bladder = 100
        faint = 100
        isFainted = false
        time_since_decrease = 0
        hunger = 0
        penalties = 0
        playIdleAnimation()
        saveState()
    }
    
    func update() {
        if (time_since_decrease > 30 && abs(glucose_level) > 50 || glucose_level > 75 || glucose_level < -75) {
            penalties = penalties + 1
        } else if (hunger > 75) {
            playFaintAnimation()
            penalties = penalties + 1
        }
        
        if (glucose_level < 50) {
            isFainted = false
            playIdleAnimation()
        }
        
        if (abs(glucose_level) <= 95) {
            faint = 100 - abs(glucose_level)
        } else {
            faint = 5
        }
        
        if (abs(glucose_level) <= 90) {
            bladder = 100 - abs(glucose_level)
        } else {
            bladder = 10
        }
        
        // do_pee()
        do_faint()
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
    }
    
    func peeNotification() {
        sleep(50)
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "onPee", object: nil))
    }
    
    func faintNotification() {
        sleep(20)
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "onFaint", object: nil))
    }
    
    func increment_t() {
        time_since_decrease += 1
        glucose_level += time_since_decrease
        increment_hunger()
    }
    
    func increment_hunger() {
        hunger += 1
    }
    
    func do_pee() {
        let b = bladder
        let r = Int(arc4random_uniform(UInt32(b)))
        if (r <= 10) {
            peeNotification()
        }
    }
    
    func do_faint() {
        if (!isFainted) {
            let f = faint
            let r = Int(arc4random_uniform(UInt32(f)))
            if (r <= 5) {
                playSleepingAnimation()
            }
            faintNotification()
        }
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
        self.image = UIImage(named: "sleeping1.png")
        
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