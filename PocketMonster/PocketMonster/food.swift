//
//  food.swift
//  PocketMonster
//
//  Created by Sam Liem on 17/3/2018.
//  Copyright © 2018 Dulio Denis. All rights reserved.
//

import Foundation
import UIKit

class Food: DragImage {
    
    var glucose: Int
    
    init(frame: CGRect, glucoseLevel: Int) {
        glucose = glucoseLevel;
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder, glucoseLevel: Int) {
        glucose = glucoseLevel
        super.init(coder: aDecoder)
    }
    
    required init?(coder aDecoder: NSCoder) {
        glucose = 0
        super.init(coder: aDecoder)
    }
   
}