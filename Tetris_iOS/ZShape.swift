//
//  ZShape.swift
//  Tetris_iOS
//
//  Created by Ryan Leung on 2020-08-30.
//  Copyright © 2020 Ryan Leung. All rights reserved.
//

class ZShape: Shape {
    /*
     
     Orientation 0 and 180
     
       • | 0 |
     
     | 2 | 1 |
     
     | 3 |
     
     Orientation 90 and 270
     
     | 0 | 1•|
     
         | 2 | 3 |
     
     • marks the row/column indicator for the shape
     
     */
    
    override var blockRowColumnPosition: [Orientation : Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero: [(1, 0), (1, 1), (0, 1), (0, 2)],
            Orientation.Ninety: [(-1, 0), (0, 0), (0, 1), (1, 1)],
            Orientation.OneEighty: [(1, 0), (1, 1), (0, 1), (0, 2)],
            Orientation.TwoSeventy: [(-1, 0), (0, 0), (0, 1), (1, 1)]
        ]
    }
    
    override var bottomBlocksForOrientations: [Orientation : Array<Block>] {
        return [
            Orientation.Zero: [blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.Ninety: [blocks[FirstBlockIdx], blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
            Orientation.OneEighty: [blocks[SecondBlockIdx], blocks[FourthBlockIdx]],
            Orientation.TwoSeventy: [blocks[FirstBlockIdx], blocks[ThirdBlockIdx], blocks[FourthBlockIdx]],
        ]
    }
}
