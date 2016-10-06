//
//  Sudoku.swift
//  Sudoku
//
//  Created by Nignesh on 2016-10-04.
//  Copyright © 2016 patel.nignesh2108@gmail.com. All rights reserved.
//

import Foundation
import UIKit

/* Represent each squre of grid as GridCell */
struct GridCell {

    var value : String = ""

    init(_ value: String = "") {
        self.value = value
    }
    
    func getDescription() -> String{
        return value == "0" ? "." : value
    }
    //Append digit to value string
    mutating func addDigitToValue(digit: String) {
        value = value.appending(digit)
    }
    //Remove digit from value string
    mutating func removeDigitFromVal(digit: String) {
        value = value.replacingOccurrences(of:digit, with: "")
    }
}

/* Sudoku grid */
class Grid {
    
    private let rows : Int = 9
    private let columns : Int = 9
    private var board: [[Int]] = [[9]]
    private var gridUnits = [[[Int]]]()
    private var gridPeers = [[Int]]()
    public var values : [GridCell]!
    
    init() {
        // precalculate peers and unit
        calculatePeersAndUnits();
    }
    
    // ===================================== CALCULATE PEERS AND UNITS ===================================== //
    // MARK:- calculate peers and unit methods
    
    private func calculatePeersAndUnits() {
        
        //peers and units for each position between 0..81
        for i in 0...(rows * columns)-1 {
            
            //calculate units
            let units = cellUnits(forPosition: i)
            gridUnits.append(units)
            
            //calculate peers
            let peers = cellPeers(forPosition: i)
            gridPeers.append(peers)
        }
    }
    
    //columns 1-9, rows A-I, and a collection of nine squares call a unit
    private func cellUnits(forPosition x :Int) -> [[Int]] {
        
        //row
        var row = x / columns
        var rowUnit = [Int](repeating: 0, count: columns)
        
        for column in 0...columns-1 {
            
            rowUnit[column] = row * columns + column
        }
        
        //column
        var column = x % rows
        var columnUnit = [Int](repeating: 0, count: rows)
        
        for row in 0...rows-1 {
            
            columnUnit[row] = row * columns + column
        }
        
        //box 3*3
        row = 3 * (x / (3 * columns))
        column = 3 * ((x % rows) / 3)
        
        var boxUnit = [Int](repeating: 0, count: 3 * 3)
        
        for i in 0...2 {
            
            for j in 0...2 {
                
                let pos = i * 3 + j
                boxUnit[pos] = (row + i) * columns + (column + j)
            }
        }
        
        return [rowUnit, columnUnit, boxUnit]
    }
    
    //The squares that share a unit called peers
    private func cellPeers(forPosition x :Int) -> [Int] {
        
        var peers = [Int]()
        
        //row
        var row = x / columns
        
        for column in 0...columns-1 {
            
            let pos = row * columns + column
            if pos != x && !peers.contains(pos) {
                
                peers.append(pos)
            }
        }
        
        //column
        var column = x % rows
        
        for row in 0...rows-1 {
            
            let pos = row * columns + column
            if pos != x && !peers.contains(pos) {
                
                peers.append(pos)
            }
        }
        
        //box 3*3
        row = 3 * (x / (3 * columns))
        column = 3 * ((x % rows) / 3)
        
        for i in 0...2 {
            
            for j in 0...2 {
                
                let pos = (row + i) * columns + (column + j)
                if pos != x && !peers.contains(pos) {
                    
                    peers.append(pos)
                }
            }
        }
        
        return peers
    }
    
    // ===================================== PARSE A GRID ===================================== //
    // MARK:- Parse a Grid methods
    
    /* Create GridCell array from grid string, replace "." wiyh "0"  */
    func gridValue(gridString: String) -> [GridCell] {
        
        var inputValues = [GridCell]()
        for i in 0..<(gridString.characters.count) {

            var cell = GridCell()
            var char = gridString[i]
            char = char == "." ? "0" : char
            
            cell.addDigitToValue(digit:String(char))
            inputValues.append(cell)
        }
        
        /* assesrt - input array must have 81 values */
        precondition(inputValues.count == 81, "Invalid Input!")
        
        return inputValues
    }
    
    /* Create values array from grid, where each squre has set of possible values  */
    func parseGrid(gridString: String){
        
        //For start let say every cell in grid has value "123456789"
        values = [GridCell] (repeating: GridCell("123456789"), count: 9 * 9)
        
        let intValues = gridValue(gridString: gridString)
        
        for i in 0..<intValues.count {
            
            if Int(intValues[i].value)! > 0 {
                
                //Assign value string to squre
                if assignValueTo(squre: i, value: intValues[i].value) == nil {
                    
                    print("Can not assign value")
                   return // Fail if we can't assign value to square i.
                }
            }
        }
    }
    
    func solvePuzzle() -> [GridCell]? {
        
        return searchForPossibilities()
    }
    
    // ===================================== CONSTARINTS PROPAGATION ===================================== //
    // MARK:- Constraint Propagation methods
    
    /* Eliminate all the other values except digit from values[s] and propagate. */
    private func assignValueTo(squre: Int,value digit: String) -> [GridCell]? {
        
        //remove digit from value of squre
        var otherValues = (values?[squre])! as GridCell
        otherValues.removeDigitFromVal(digit: digit)
        
        for char in otherValues.value.characters{
            
            if eliminateDigitFrom(squre: squre, digit: String(char)) == nil {
                
                //Return nil if a contradiction is detected.
                return nil
            }
        }
        
        //if contradiction then return values
        return values
    }
    
    /* Eliminate digit from values[s]; propagate when values or places <= 2. */
    private func eliminateDigitFrom(squre: Int, digit: String) -> [GridCell]? {
        
        // Check if already eliminated
        if !(values[squre].value.contains(digit)) {
            return values
        }
        
        //Else remove digit from squre value
        values[squre].removeDigitFromVal(digit: digit)
        
        // 1. "If a square has only one possible value, then eliminate that value from the square's peers."
        
        //If a square sqr is reduced to one value digit, then eliminate digit from the sqr-peers.
        let count = values[squre].value.characters.count
        if count == 0 {
            
            return nil // Contradiction: removed last value
        
        }else if count == 1 {
            
            let digit : String = values[squre].value[0]
            
            //Eliminate digit from sqr-peers
            for sqr in gridPeers[squre] {
                
                if eliminateDigitFrom(squre: sqr, digit: digit) == nil {
                    return nil
                }
            }
        }
        
        // 2. "If a unit has only one possible place for a value, then put the value there."
        for unit in gridUnits[squre] {
            var dPlaces = 0, dPlacesCount = 0
            for sqr in unit {
                
                if (values[sqr].value.contains(digit)) {
                    dPlaces = sqr
                    dPlacesCount += 1
                }
            }
            if dPlacesCount == 0 {
                return nil // Contradiction: no place for this value
                
            }else if dPlacesCount == 1 {
                
                // digit can only be in one place in unit; assign it there
                if assignValueTo(squre: dPlaces, value: digit) == nil {
                    return nil
                }
            }
        }
        return values
    }

    // ===================================== SEARCH ===================================== //
    // MARK:- search methods
    
    /* Check if Sudoku is solved. - every squre in grid must have only 1 digit*/
    private var solved: Bool {
        for s in values! {
            if s.value.characters.count != 1 {
                return false
            }
        }
        return true
    }
    
    /* Backtracking search - Using depth-first search and propagation, try all possible values. */
    private func searchForPossibilities() -> [GridCell]? {
        
        // check if solved
        if solved {
            return values
        }
        
        // get the squre with the fewest possibilities to check. i.e. squre with smaller value string in length
        var minCount = Int.max, sqr = 0
        for i in 0..<(rows * columns) {
            
            let count = values[i].value.characters.count
            if count > 1 && count < minCount {
                minCount = count
                sqr = i
            }
        }
        
        // Try all possible values from value-string of squre
        for char in (values[sqr].value.characters){
            
            // Save state, we need to restore it if it reaches to dead end.
            let newValues = self.values
            
            //Assign value string to squre
            if assignValueTo(squre: sqr, value: String(char)) != nil {
                
                //continue to search for possibilities
                searchForPossibilities()
            }
            
            //Dead end - restore state
            if !solved {
                self.values = newValues
            }
        }
        
        return nil
    }
}
