//
//  TimerHandle.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/10/2.
//  Copyright © 2018 t19960804. All rights reserved.
//

import Foundation
import UIKit

class TimerHandle {
    var minuteCount = 0
    var counter  = Float()
    

    //計時器累加並顯示
    func UpdateTimer() -> String{
        counter = counter + 00.1
        if counter <= 9.9
        {

            return "\(minuteCount)分 0\(String(format: "%.1f", counter))秒"
        }
        else if counter >= 59.9
        {
            minuteCount = minuteCount + 1
            counter = 00.0
            return "\(minuteCount)分 \(String(format: "%.1f", counter))秒"
        }
        else
        {
            return  "\(minuteCount)分 \(String(format: "%.1f", counter))秒"
        }
        
        
        
    }
    
}
