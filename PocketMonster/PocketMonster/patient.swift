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
    
    var glucose_level = 0
    var stroke_count = 0
    var bladder = 0.5
    var faint = 0
    var t = 0
    var hunger = 0
    var penalties = 0
    
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
    
    func update() {
        
    }
    
    func insulin(insulin: Int) {
        glucose_level = glucose_level - insulin
        t = 0
    }
    
    func eat(glucose: Int) {
        glucose_level = glucose_level + glucose
        hunger = 0
    }
    
    func exercise(glucose: Int) {
        glucose_level = glucose_level - glucose
        t = 0
        hunger += 10
    }
    
    func increment_t() {
        t += 1
        glucose_level += t
    }
    
    func increment_hunger() {
        hunger += 1
    }
}