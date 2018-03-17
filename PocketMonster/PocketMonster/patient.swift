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
    
    var glucose_level : Double = 0
    var insulin_level : Double = 5
    var penalties = 0
    
    var stroke_count = 0
    var health = 100
    var bladder_multiplier : Double = 0.5
    var faint_multiplier : Double = 0
    var time_since_exercise : Double = 0
    var time_since_eat : Double = 0
    
    var time_since_launch : Double = 0
    
    func saveGameState() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(glucose_level, forKey: "glucose_level")
        defaults.setObject(insulin_level, forKey: "insulin_level")
        defaults.setObject(penalties, forKey: "penalties")
        defaults.setObject(stroke_count, forKey: "stroke_count")
        defaults.setObject(health, forKey: "health")
        defaults.setObject(bladder_multiplier, forKey: "bladder_multiplier")
        defaults.setObject(faint_multiplier, forKey: "faint_multiplier")
        defaults.setObject(time_since_exercise, forKey: "time_since_exercise")
        defaults.setObject(time_since_eat, forKey: "time_since_eat")
        
        defaults.setObject(time_since_eat, forKey: "time_since_launch")
    }
    
    func loadGameState() {
        let defaults = NSUserDefaults.standardUserDefaults()
        glucose_level = defaults.doubleForKey("glucose_level")
        insulin_level = defaults.doubleForKey("insulin_level")
        penalties = defaults.integerForKey("penalties")
        stroke_count = defaults.integerForKey("stroke_count")
        health = defaults.integerForKey("health")
        bladder_multiplier = defaults.doubleForKey("bladder_multiplier")
        faint_multiplier = defaults.doubleForKey("faint_multiplier")
        time_since_exercise = defaults.doubleForKey("time_since_exercise")
        time_since_eat = defaults.doubleForKey("time_since_eat")
        
        time_since_launch = defaults.doubleForKey("time_since_launch")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playIdleAnimation()
    }
    
    func playIdleAnimation() {
        self.image = UIImage(named: "idle1.png") // TODO: find n idle images
        self.animationImages = nil
        
        var imageArray = [UIImage]()
        for var x = 1; x <= 4; x++ { // x <= n
            let img = UIImage(named: "idle\(x).png") // TODO: find n idle images
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
    
    func incrementTime() {
        time_since_launch = time_since_launch + 1
        time_since_exercise = time_since_exercise + 1
        time_since_eat = time_since_eat + 1
    }
    
    func update() {
        
    }
    
    func insulinCheck() {
        
    }
    
    func eat(glucose: Int) {
        glucose_level += Double(glucose)
    }
    
    func exercise() {
        
    }
    
    
}