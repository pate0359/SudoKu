//
//  ViewController.swift
//  Sudoku
//
//  Created by Nignesh on 2016-10-04.
//  Copyright © 2016 patel.nignesh2108@gmail.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var gridItems = [GridCell]()
    
    @IBOutlet var sudokuGrid: UICollectionView!
    @IBOutlet var verticalLayoutConstraint: NSLayoutConstraint!
    
    
    let grid = Grid()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set up for collection display view style
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        sudokuGrid!.collectionViewLayout = layout
        sudokuGrid.layer.borderWidth = 2
        sudokuGrid.layer.borderColor = UIColor.black.cgColor
        self.automaticallyAdjustsScrollViewInsets = false
        
        gridItems = grid.gridValue(gridString:"7.....4...2..7..8...3..8.799..5..3...6..2..9...1.97..6...3..9...3..4..6...9..1.35")
        self.sudokuGrid.reloadData()
        //print(display(values: inputGrid))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Action Methods
    @IBAction func btnSolveClicked(_ sender: AnyObject) {
        
        grid.parseGrid(gridString:"7.....4...2..7..8...3..8.799..5..3...6..2..9...1.97..6...3..9...3..4..6...9..1.35")
        grid.solvePuzzle()
        gridItems = grid.values!
        self.sudokuGrid.reloadData()
        
        //print(display(values: grid.values!))
        
    }
    @IBAction func btnResetClicked(_ sender: AnyObject) {
        
        gridItems = grid.gridValue(gridString:"7.....4...2..7..8...3..8.799..5..3...6..2..9...1.97..6...3..9...3..4..6...9..1.35")
        self.sudokuGrid.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gridItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"gridCell", for: indexPath as IndexPath) as! SudokuCell
        
        // Insert cell data
        cell.initWithItemFor(indexPath: indexPath, item: gridItems[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let width = self.sudokuGrid.bounds.size.width/9
        let height = self.sudokuGrid.bounds.size.height/9
        return CGSize(width: width, height: height)
    }
}

extension ViewController{
    
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

