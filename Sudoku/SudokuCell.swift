//
//  SudokuCell.swift
//  Sudoku
//
//  Created by Nignesh on 2016-10-05.
//  Copyright © 2016 patel.nignesh2108@gmail.com. All rights reserved.
//

import UIKit

class SudokuCell: UICollectionViewCell {
    
    @IBOutlet var label : UILabel!
    
    // Initilize cell data
    func initWithItemFor(indexPath: IndexPath,item : GridCell)  {
        
        //Left border of cell
        self.layer.addBorder(edge: .left, color: UIColor.black, thickness: (indexPath.row % 3 == 0 ? 2 : 1))
       
        //Bottom border of cell
        //Get column
        let column = indexPath.item / 9 + 1
        self.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: (column % 3 == 0 ? 2 : 1))
        
        //Grid Value
        self.label.text = item.getDescription()
    }
}
