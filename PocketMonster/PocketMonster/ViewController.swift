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
    
    @IBOutlet weak var bloodGlucoseBar: UISlider!
    
    @IBOutlet weak var doExercise: UIButton!
    @IBOutlet weak var injectInsulin: UIButton!
    
    var timer: NSTimer!
    
//    var peeTimer: NSTimer!
//    var faintTimer: NSTimer!

    var sfxBite:     AVAudioPlayer!
    var sfxDeath:    AVAudioPlayer!
    var sfxSkull:   AVAudioPlayer!
    
    let DIM_ALPHA: CGFloat  = 0.2
    let OPAQUE: CGFloat     = 1.0
    let MAX_PENALTIES       = 3
    
    var e = 0
    
    func initFood(food: Food, glucoseLevel: Int) {
        food.dropTarget = patient
        food.glucose = glucoseLevel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // patient.restart()
        if NSUserDefaults.standardUserDefaults().objectForKey("penalties") != nil {
            patient.loadState()
        }
        
        let exerciseLevel = NSUserDefaults.standardUserDefaults().integerForKey("exerciseLEVEL")
        if exerciseLevel > 0 {
            patient.exercise(exerciseLevel)
        }
        
        var peeTimer = NSTimer.scheduledTimerWithTimeInterval(135, target: self, selector:"hardCodePee", userInfo: nil, repeats: false)
        var faintTimer = NSTimer.scheduledTimerWithTimeInterval(160, target: self, selector:"hardCodeFaint", userInfo: nil, repeats: false)
        
        initFood(chicken, glucoseLevel: 0)
        initFood(broccoli, glucoseLevel: 1)
        initFood(apple, glucoseLevel: 10)
        initFood(fries, glucoseLevel: 20)
        initFood(chocolate, glucoseLevel: 50)
    
        penalty1Image.alpha = OPAQUE
        penalty2Image.alpha = OPAQUE
        penalty3Image.alpha = OPAQUE
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "foodItemDropped:", name: "onTargetDropped", object: nil)
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: "showPeeNotification:", name: "onPee", object: nil)
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: "showFaintNotification:", name: "onFaint", object: nil)
        
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
        
        changeGameState()
        startTimer()
    }
    
    func showPeeNotification(notification: NSNotification) {
        hardCodePee()
    }
    
    func showFaintNotification(notification: NSNotification) {
        hardCodeFaint()
    }
    
    @IBAction func exercise(sender: UIButton, forEvent event: UIEvent) {
        patient.saveState()
    }
    
    @IBAction func insulin(sender: UIButton, forEvent event: UIEvent) {
        patient.insulin()
        changeGameState()
    }
    
    func foodItemDropped(notification: NSNotification) {
        if let g = notification.userInfo?["glucose"] as? Int {
            sfxBite.play()
            print("before \(g): \(patient.glucose_level)")
            patient.eat(g)
            print("after: \(patient.glucose_level)")
            changeGameState()
            startTimer()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(60.0, target: self, selector: "minuteElapsed", userInfo: nil, repeats: true)
        
        
    }
    
    func hardCodePee() {
        let alert = UIAlertController(title: "Your friend peed!", message: "Those with diabetes will likely suffer from increase rate of peeing.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: { action in switch action.style{
        default:
            // self.changeGameState()
            // self.viewDidLoad()
            print("hello")
            }}))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func hardCodeFaint() {
        if (!patient.isFainted) {
            let alert = UIAlertController(title: "Your friend fainted from hunger!", message: "Your friend had no energy and passed out!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: { action in switch action.style{
            default:
            // self.changeGameState()
            // self.viewDidLoad()
            print("hello")
            }}))
            self.presentViewController(alert, animated: true, completion: nil)
            patient.playFaintAnimation()
        }
    }
    
    
    func minuteElapsed() {
        patient.increment_t()
        changeGameState()
    }
    
    @IBAction func bloodGlucoseBarChange(sender : UISlider) {
        patient.glucose_level = Int(sender.value)
        changeGameState()
    }
    
    func changeGameState() {
        
        patient.update()
        
        // UPDATE SUGAR
        let blood_sugar = patient.glucose_level
        
        print("glucose: \(blood_sugar)")
        
        bloodGlucoseBar.value = Float(blood_sugar)
        
        // UPDATE HEARTS
        let penalties = patient.penalties
        
        if penalties > 0 {
            sfxSkull.play()
            penalty3Image.alpha = DIM_ALPHA
        } else {
            penalty1Image.alpha = OPAQUE
            penalty2Image.alpha = OPAQUE
            penalty3Image.alpha = OPAQUE
        }
        
        if penalties > 1 {
            penalty2Image.alpha = DIM_ALPHA
        }
        if penalties > 2 {
            penalty1Image.alpha = DIM_ALPHA
        }
        
        if penalties >= MAX_PENALTIES {
            gameOver()
        }
    }
    
    func gameOver() {
        if (timer != nil) {
            timer.invalidate()
        }
        patient.playDeathAnimation()
        sfxDeath.play()
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Game Over", message: "Diabetes is a very serious condition.\n Those with it have it forever.\n If you have diabetes, we support you.\n If you know somebody with diabetes, please support them.\n Please eat healthy foods like fruits and vegetables instead of sugary foods like sweets and pizza.\n\n Eat right, exercise often, be healthy!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: { action in switch action.style{
            default:
                self.patient.restart()
                self.changeGameState()
                self.viewDidLoad()
        }}))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

