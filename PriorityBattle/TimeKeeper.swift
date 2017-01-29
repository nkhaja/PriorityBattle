//
//  TimeKeeper.swift
//  PriorityBattle
//
//  Created by Nabil K on 2017-01-28.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import Foundation

class TimeKeeper {
    
    var timer: Timer?
    var cycle = 0
    var currentTime = 0
    
    init(cycle:Int ){
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        self.cycle = cycle
    }
    

    
    @objc func updateTime(){
        if currentTime > 0 {
            currentTime -= 1
//            timerLabel.text! = String(currentTime)
        }
            
        else{
            currentTime = cycle
//            timerLabel.text! = String(currentTime)
        }
    }

}
