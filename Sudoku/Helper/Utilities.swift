//
//  Utilities.swift
//  Sudoku
//
//  Created by Nignesh on 2016-10-05.
//  Copyright © 2016 patel.nignesh2108@gmail.com. All rights reserved.
//

import Foundation

class Utilities {
    
    static let sharedInstance = Utilities()
    var arrayExamples : [String]?
    
    private func arrayFromContentsOfFile(fileName: String) -> [String]? {
        
        print(Bundle.main.path(forResource: fileName, ofType: "txt"))
        guard let path = Bundle.main.path(forResource: fileName, ofType: "txt") else {
            return nil
        }
        
        do {
            let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
            return content.components(separatedBy: "\n")
        } catch _ as NSError {
            return nil
        }
    }
    
    public func getPuzzle() -> String? {
        
        //Get puzzle examples from resource file
        if arrayExamples == nil{
            
            let array = self.arrayFromContentsOfFile(fileName: "examples")
            if (array == nil){ return nil }
            
            //Assign to global array so we dont need to parse .txt file on each call
            arrayExamples = array
        }
        
        //Pick random example
        let randomIndex = Int(arc4random_uniform(UInt32((arrayExamples?.count)!)))
        return arrayExamples?[randomIndex]
    }
}
