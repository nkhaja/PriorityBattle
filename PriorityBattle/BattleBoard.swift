//
//  BattleBoard.swift
//  PriorityBattle
//
//  Created by Nabil K on 2017-01-28.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import Foundation

class BattleBoard {
    
    var items: [Item]
    var pairs: [(Item, Item)] = []
    var currentPair: (Item, Item)?
    
    init(items: [Item]){
        self.items = items
        makeCombos()
        self.currentPair = pairs.popLast()
    }
    
    func makeCombos(){
        for i in 0 ..< items.count{
            for j in (i+1)..<items.count {
                pairs.append((items[i],items[j]))
            }
        }
    }
    
    func getNext() -> (Item, Item){
       return pairs.popLast()!
    }
    
    
    
}
