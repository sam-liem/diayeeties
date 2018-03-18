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
    var bladder = 100 // pee multiplier, takes values from 100 (10% chance of pee) down to 10 (100% chance of pee)
    var faint = 0 // faint multiplier, takes values from 100 (5% chance of faint) down to 5 (100% chance of faint)
    var time_since_decrease = 0 // time since last glucose decreasing activity (0 - ?)
    var hunger = 0 // hunger level 0 - 60 (at which point they starve)
    var penalties = 0 // tries or lives (0 - 3)
    
    func sendNotification(s : String, b : String) {
        let data:[String: String] = ["subject": s, "body": b]
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "onMessageSent", object: nil, userInfo: data))
    }
    
    func update() {
        if (time_since_decrease > 30 && abs(glucose_level) > 50 || glucose_level > 75 || glucose_level < -75) {
            penalties = penalties + 1
        }
        
        if (hunger > 60) {
            playFaintAnimation()
            penalties = penalties + 1
        }
        
        if abs(glucose_level) <= 90 {
            bladder = 100 - abs(glucose_level)
        } else {
            bladder = 10
        }
        
        if abs(glucose_level) <= 95 {
            faint = 100 - abs(glucose_level)
        } else {
            faint = 5
        }
        
        do_pee(bladder)
        do_faint(faint)
    }
    
    func glucose(b : Int) {
        if b < 0 {
            time_since_decrease = 0
        } else if b > 0 {
            hunger = 0
        }
        glucose_level += b
        update()
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
    
    func increment_t() {
        time_since_decrease += 1
        glucose_level -= (glucose_level / abs(glucose_level))
        hunger += 1
    }
    
    func do_pee(bladder: Int) {
        let r = Int(arc4random_uniform(UInt32(bladder)))
        if (r <= 10) {
            playPeeAnimation()
        }
    }
    
    func do_faint(faint: Int) {
        let r = Int(arc4random_uniform(UInt32(faint)))
        if (r <= 5) {
            playFaintAnimation()
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
        // TODO
        self.image = UIImage(named: "idle1.png")
        self.animationImages = nil
        
        var imageArray = [UIImage]()
        for var x = 1; x <= 4; x++ {
            let img = UIImage(named: "idle\(x).png")
            imageArray.append(img!)
        }
        
        self.animationImages = imageArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
    
    func playPeeAnimation() {
        
    }
    
    func playIdleAnimation() {
        self.image = UIImage(named: "idle1.png")
        self.animationImages = nil
        
        var imageArray = [UIImage]()
        for var x = 1; x <= 4; x++ {
            let img = UIImage(named: "idle\(x).png")
            imageArray.append(img!)
        }
        
        self.animationImages = imageArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeathAnimation() {
        self.image = UIImage(named: "dead5.png") // TODO: find n death images
        self.animationImages = nil
        
        var imageArray = [UIImage]()
        for var x = 1; x <= 5; x++ { // x <= n
            let img = UIImage(named: "dead\(x).png")
            imageArray.append(img!)
        }
        
        self.animationImages = imageArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }
}