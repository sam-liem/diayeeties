//
//  ViewController.swift
//  PocketMonster
//
//  Created by Dulio Denis on 11/5/15.
//  Copyright © 2015 Dulio Denis. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var patient:Patient!
    
    @IBOutlet weak var chicken: Food!
    @IBOutlet weak var broccoli: Food!
    @IBOutlet weak var apple: Food!
    @IBOutlet weak var fries: Food!
    @IBOutlet weak var chocolate: Food!
    
    @IBOutlet weak var penalty1Image: UIImageView!
    @IBOutlet weak var penalty2Image: UIImageView!
    @IBOutlet weak var penalty3Image: UIImageView!
    
    @IBOutlet weak var doExercise: UIButton!
    @IBOutlet weak var injectInsulin: UIButton!
    
    var timer: NSTimer!

    var sfxBite:     AVAudioPlayer!
    var sfxDeath:    AVAudioPlayer!
    var sfxSkull:   AVAudioPlayer!
    
    let DIM_ALPHA: CGFloat  = 0.2
    let OPAQUE: CGFloat     = 1.0
    let MAX_PENALTIES       = 3
    
    func initFood(food: Food, glucoseLevel: Int) {
        food.dropTarget = patient
        food.glucose = glucoseLevel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initFood(chicken, glucoseLevel: 0)
        initFood(broccoli, glucoseLevel: 5)
        initFood(apple, glucoseLevel: 30)
        initFood(fries, glucoseLevel: 60)
        initFood(chocolate, glucoseLevel: 100)
    
        penalty1Image.alpha = DIM_ALPHA
        penalty2Image.alpha = DIM_ALPHA
        penalty3Image.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "foodItemDropped:", name: "onTargetDropped", object: nil)
        
        do {
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
        startTimer()
    }
    
    @IBAction func exercise(sender: UIButton, forEvent event: UIEvent) {
        print("hi")
    }
    
    @IBAction func insulin(sender: UIButton, forEvent event: UIEvent) {
        print("hello")
    }
    
    func foodItemDropped(notification: NSNotification) {
        print("durr")
        if let g = notification.userInfo?["glucose"] as? Int {
            sfxBite.play()
            print("item dropped onto patient. g: \(g)")
            patient.eat(g)
            changeGameState()
            startTimer()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        patient.increment_t()
        
        // UPDATE SUGAR
        // let blood_sugar = patient.glucose_level
        
        //let blood_sugar = arc4random_uniform(101) - 100 // for debugging
        
        //
        
        
        // UPDATE HEARTS
        let penalties = patient.penalties
        
        if penalties == 1 {
            penalty1Image.alpha = OPAQUE
            penalty2Image.alpha = DIM_ALPHA
            sfxSkull.play()
        } else if penalties == 2 {
            penalty2Image.alpha = OPAQUE
            penalty3Image.alpha = DIM_ALPHA
            sfxSkull.play()
        } else if penalties == 3 {
            penalty3Image.alpha = OPAQUE
            sfxSkull.play()
        } else {
            penalty1Image.alpha = DIM_ALPHA
            penalty2Image.alpha = DIM_ALPHA
            penalty3Image.alpha = DIM_ALPHA
        }
        
        if penalties >= MAX_PENALTIES {
            gameOver()
        }
    }
    
    func gameOver() {
        timer.invalidate()
        patient.playDeathAnimation()
        sfxDeath.play()
    }
}

