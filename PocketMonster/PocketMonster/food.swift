//
//  food.swift
//  PocketMonster
//
//  Created by Sam Liem on 17/3/2018.
//  Copyright © 2018 Dulio Denis. All rights reserved.
//

import Foundation
import UIKit

class Food: UIImageView {
    
    var glucose: Int
    
    var originalPosition: CGPoint!
    var dropTarget: UIView?

    override init(frame: CGRect) {
        glucose = 0
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        glucose = 0
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        originalPosition = self.center
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.locationInView(self.superview)
            self.center = CGPointMake(position.x, position.y)
            
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first, let target = dropTarget {
            let position = touch.locationInView(self.superview)
            let t = self.superview?.convertRect(target.bounds, fromView: target)
            // if we dropped the image onto the target fire off a onTargetDropped notification
            if CGRectContainsPoint(t!, position) {
                let data:[String: Int] = ["glucose": glucose]
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "onTargetDropped", object: nil, userInfo: data))
            }
        }
        self.center = originalPosition
    }
}