//
//  ViewController.swift
//  Sudoku
//
//  Created by Nignesh on 2016-10-04.
//  Copyright © 2016 patel.nignesh2108@gmail.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let grid = Grid()
        
        let inputGrid = grid.gridValue(gridString:"7.....4...2..7..8...3..8.799..5..3...6..2..9...1.97..6...3..9...3..4..6...9..1.35")
        print("=============== INPUT ===============")
        print(display(values: inputGrid))
        
        grid.parseGrid(gridString:"7.....4...2..7..8...3..8.799..5..3...6..2..9...1.97..6...3..9...3..4..6...9..1.35")
        grid.solvePuzzle()
        print("=============== OUTPUT ===============")
        
            print(display(values: grid.values!))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Print grid.
    func display(values : [GridCell]) ->String {
        
        if values.count <= 0 {
            return "value count ZERO"
        }
        
        // get maximum string length of each squre value
        var maxLen = 0
        for v in values {
            
            let cell = v as GridCell
            maxLen = max(maxLen, cell.value.characters.count)
        }

        // Build table grid
        var row = [String]()
        for r in 0..<9 {
            var col = [String]()
            
            for i in 0..<9 {
                
                let cell = (values[r * 9 + i]) as GridCell
                col.append((cell.value as NSString).padding(toLength: maxLen, withPad: " ", startingAt: 0))
            }
            
            let c0 = col[0...2].joined(separator: " ")
            let c1 = col[3...5].joined(separator: " ")
            let c2 = col[6...8].joined(separator: " ")
            row.append([c0,c1,c2].joined(separator: "|"))
        }
        
        let r0 = row[0...2].joined(separator: "\n")
        let r1 = row[3...5].joined(separator: "\n")
        let r2 = row[6...8].joined(separator: "\n")
        return [r0,r1,r2].joined(separator: "\n-----------------\n") + "\n"
    }

}

