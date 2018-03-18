//
//  ExerciseController.swift
//  PocketMonster
//
//  Created by Sam Liem on 18/3/2018.
//  Copyright © 2018 Dulio Denis. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ExerciseController: UIViewController {
    
    var progress : Float = 0
    var level : Int = 0
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var exerciseLevel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake && level < 10 {
            progress = progress + 0.1

            level = level + 1
            
            progressBar.progress = progress
            exerciseLevel.text = String(level)
            
            NSUserDefaults.standardUserDefaults().setObject(level * 10, forKey: "exerciseLEVEL")
        }
    }
    
}