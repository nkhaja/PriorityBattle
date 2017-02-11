//
//  SplitDecisionTests.swift
//  SplitDecisionTests
//
//  Created by Nabil K on 2017-02-10.
//  Copyright © 2017 MakeSchool. All rights reserved.
//

import XCTest
@testable import SplitDecision

class SplitDecisionTests: XCTestCase {
    var battleBoard: BattleBoard?
    
    override func setUp() {
        super.setUp()
        let data = ["a","b","c","d"]
        let items = data.map{return Item(name:$0)}
        battleBoard = BattleBoard(items: items)
  
    }
    
    func testMakeCombos(){
        battleBoard!.makeCombos()
//        XCTAssertEqual(battleBoard!.items.count, 5)
        XCTAssertEqual(battleBoard!.pairs.count, 6)
    }
    
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
