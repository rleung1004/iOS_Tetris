//
//  GameViewController.swift
//  Tetris_iOS
//
//  Created by Levona Yim on 2020-08-29.
//  Copyright © 2020 Ryan Leung. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var scene: GameScene!
    var gameLogic: GameLogic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        scene.tick = didTick
        
        gameLogic = GameLogic()
        gameLogic.startGame()
        
        skView.presentScene(scene)
        
        scene.addPreviewShapeToScene(shape: gameLogic.nextShape!) {
            self.gameLogic.nextShape?.moveTo(column: StartingColumn, row: StartingRow)
            self.scene.movePreviewShape(shape: self.gameLogic.nextShape!) {
                let nextShapes = self.gameLogic.newShape()
                self.scene.startTimer()
                self.scene.addPreviewShapeToScene(shape: nextShapes.nextShape!) {}
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func didTick() {
        gameLogic.fallingShape?.lowerShapeByOneRow()
        scene.redrawShape(shape: gameLogic.fallingShape!, completion: {})
    }
}
