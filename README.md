# SudoKu
One of the most popular puzzle games of all time.

## Introduction
Sudoku is demo application to solve sudoku puzzle programmatically by using Peter Norvig algorithm. Algorithm created in Swift3.0 is very easy to use. Application will render random puzzle on screen from available examples (.txt file contains list of puzzles, we can add more puzzles easily), the solution (calculated by algorithm) will render on screen when user hit "solve".

![puzzle] (https://github.com/pate0359/Sudoku/blob/master/Screens/1.png)
![solution] (https://github.com/pate0359/Sudoku/blob/master/Screens/2.png)


## Development
* Targeted iOS version : iOS9.0+
* IDE : Xcode8.0
* Programming language used to develop : Swift 3.0
* Multiscreen support with Autolayout (portrait mode)
* Sufficient unit test cases is implemented to ensure application functinalities.
* Taken care of code modularity
* Application has used "Test Driven Development" technique while development. 

## Deployment
* Checkout, Clone or download this repository. 
* You dont need any chnage to run this application if you are using Xcode8, or you require to update Xcode latest version as Xcode 8 support Swift 3.0
* You can copy algorithm file "Sudoku.swift" in your project and create your own sudoku game. 

## Usage Example

``` javascript
//Create Grid class instance
let grid = Grid()
let puzzle = ".524.........7.1..............8.2...3.....6...9.5.....1.6.3...........897........"
//Parse puzzle string
grid.parseGrid(gridString:puzzle)
//Call solve method
grid.solvePuzzle()

//Get solved puzzle value
let solvedPuzzle = grid.values!

```

## Algorithm and Reference
* **Peter Norvig** algorith is used for this application. It solves every sudoku puzzle by **constaints propogation** and **search**. You can find more details about algorithm here [Peter Norvig Algorith](http://norvig.com/sudoku.html).

## Author
* Application is initially developed by Nignesh Patel. You can reach me out for any queries at [patel.nignesh2108@gmail.com](mailto:patel.nignesh2108@gmail.com)
