//
//  SudokuTests.swift
//  SudokuTests
//
//  Created by Nignesh on 2016-10-04.
//  Copyright © 2016 patel.nignesh2108@gmail.com. All rights reserved.
//

import Foundation
import XCTest
@testable import Sudoku

class SudokuTests: XCTestCase {
    
    let grid = Grid()
    var vc : ViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //calculate units and peers
        grid.calculatePeersAndUnits()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
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
            
            let grid = ".524.........7.1..............8.2...3.....6...9.5.....1.6.3...........897........"
            self.grid.parseGrid(gridString:grid)
            _ = self.grid.solvePuzzle()
        }
    }
   
    func testPeers()  {
        
        // Squre A1
        XCTAssertEqual(self.grid.gridPeers[0].count , 20)
        XCTAssertEqual(self.grid.gridPeers[0].sorted{ $0 < $1 },[1, 2, 3 ,4 ,5 ,6 ,7 ,8, 9, 10, 11, 18, 19, 20, 27, 36, 44, 54, 63, 72])
        
        // Squre C4
        XCTAssertEqual(self.grid.gridPeers[21].count , 20)
        XCTAssertEqual(self.grid.gridPeers[0].sorted{ $0 < $1 },[3, 4, 5, 12 ,13 ,14, 18, 19, 20, 22, 23 , 24, 25, 26, 30, 39, 48, 57, 66, 75])
        
    }
    
    func testUnits()  {
        
        // Squre A1
        XCTAssertEqual(self.grid.gridUnits[0].count, 3)
        
        let unitA1 = [[18, 19, 20, 21, 22, 23, 24, 25, 26],
                      [1, 10, 19, 28, 37, 46, 55, 64, 73],
                      [0, 1, 2, 9, 10, 11, 18, 19, 20]]
        XCTAssertEqual(self.grid.gridUnits[0][0], unitA1[0])
        XCTAssertEqual(self.grid.gridUnits[0][1], unitA1[1])
        XCTAssertEqual(self.grid.gridUnits[0][2], unitA1[2])
        
        // Squre C4
        XCTAssertEqual(self.grid.gridUnits[21].count, 3)
        let unitC4 = [[0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
                      [0, 9, 18, 27, 36, 45, 54, 63, 72],
                      [0, 1, 2, 9, 10, 11, 18, 19, 20]]
        XCTAssertEqual(self.grid.gridUnits[0][0], unitC4[0])
        XCTAssertEqual(self.grid.gridUnits[0][1], unitC4[1])
        XCTAssertEqual(self.grid.gridUnits[0][2], unitC4[2])
    }
    
    func testParseInputPuzzleString()  {
     
        let puzzle = "..8.9.1...6.5...2......6....3.1.7.5.........9..4...3...5....2...7...3.8.2..7....4"
        let parsedItems = self.grid.gridValue(gridString: puzzle)
        XCTAssertEqual(parsedItems.count, 81)
    }
    
    func testPuzzleFilePath()  {
        //Example.txt file has 50 puzzles
        XCTAssertEqual(Utilities.sharedInstance.arrayExamples?.count, 50)
    }
    
    func testGettingRandomPuzzle()  {
        
        let puzzle = "..8.9.1...6.5...2......6....3.1.7.5.........9..4...3...5....2...7...3.8.2..7....4"
        XCTAssertEqual(Utilities.sharedInstance.arrayExamples?[35], puzzle)
    }
    
    func testGridCellAddDigit()  {
        
        //parse grid to get values[]
        let grid = ".524.........7.1..............8.2...3.....6...9.5.....1.6.3...........897........"
        self.grid.parseGrid(gridString:grid)
        
        //get any random squre's value
        var cel = self.grid.values[2]
        cel.value = "123"
        cel.addDigitToValue(digit: "4")
        
        let newcel = self.grid.values[2]
        XCTAssertEqual(newcel.value , "1234")
    }
    
    func testGridCellRemoveDigit()  {
        
        //parse grid to get values[]
        let grid = ".524.........7.1..............8.2...3.....6...9.5.....1.6.3...........897........"
        self.grid.parseGrid(gridString:grid)
        
        //get any random squre's value
        var cel = self.grid.values[2]
        cel.value = "123"
        cel.removeDigitFromVal(digit: "2")
        
        let newcel = self.grid.values[2]
        XCTAssertEqual(newcel.value,"13")
    }
    
    func testSolve()  {
        
        let grid = ".524.........7.1..............8.2...3.....6...9.5.....1.6.3...........897........"
        self.grid.parseGrid(gridString:grid)
        self.grid.solvePuzzle()
        
        //Get solved puzzle value
        let gridItems = self.grid.values!
        
        let expected =
        "6 5 2|4 8 1|9 3 7\n" +
        "8 3 4|6 7 9|1 5 2\n" +
        "9 7 1|3 2 5|8 6 4\n" +
        "-----------------\n" +
        "4 6 7|8 1 2|5 9 3\n" +
        "3 1 5|7 9 4|6 2 8\n" +
        "2 9 8|5 6 3|4 7 1\n" +
        "-----------------\n" +
        "1 8 6|9 3 7|2 4 5\n" +
        "5 2 3|1 4 6|7 8 9\n" +
        "7 4 9|2 5 8|3 1 6]\n"
        
        XCTAssertEqual("\(self.vc?.display(values: gridItems))", expected)
    }
}
