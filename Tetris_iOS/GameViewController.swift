//
//  GameViewController.swift
//  Tetris_iOS
//
//  Created by Levona Yim on 2020-08-29.
//  Copyright © 2020 Ryan Leung. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, GameLogicDelegate, UIGestureRecognizerDelegate {

    var scene: GameScene!
    var gameLogic: GameLogic!
    
    var panPointReference: CGPoint?
    
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        scene.tick = didTick
        
        gameLogic = GameLogic()
        gameLogic.delegate = self
        gameLogic.startGame()
        
        skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        gameLogic.rotateShape()
    }
    
    @IBAction func didPan(_ sender: UIPanGestureRecognizer) {
        let currentPoint = sender.translation(in: self.view)
        
        if let originalPoint = panPointReference {
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                if sender.velocity(in: self.view).x > CGFloat(0) {
                    gameLogic.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    gameLogic.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .began {
            panPointReference = currentPoint
        }
    }
    
    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer) {
        gameLogic.dropShape()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UISwipeGestureRecognizer {
            if otherGestureRecognizer is UIPanGestureRecognizer {
                return true
            }
        } else if gestureRecognizer is UIPanGestureRecognizer {
            if otherGestureRecognizer is UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
    
    func didTick() {
        gameLogic.letShapeFall()
    }
    
    func nextShape() {
        let newShapes = gameLogic.newShape()
        guard let fallingShape = newShapes.fallingShape else {
            return
        }
        self.scene.addPreviewShapeToScene(shape: newShapes.nextShape!) {}
        self.scene.movePreviewShape(shape: fallingShape) {
            self.view.isUserInteractionEnabled = true
            self.scene.startTimer()
        }
    }
    
    func gameDidStart(gameLogic: GameLogic) {
        levelLabel.text = "\(gameLogic.level)"
        scoreLabel.text = "\(gameLogic.score)"
        scene.tickLengthMillisec = TickLengthLevelOne
        
        if gameLogic.nextShape != nil && gameLogic.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(shape: gameLogic.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(gameLogic: GameLogic) {
        view.isUserInteractionEnabled = false
        scene.stopTimer()
        scene.playSound(sound: "gameover.mp3")
        scene.animateCollapsingLines(linesToRemove: gameLogic.removeAllBlocks(), fallenBlocks: gameLogic.removeAllBlocks()) {
            gameLogic.startGame()
        }
    }
    
    func gameDidLevelUp(gameLogic: GameLogic) {
        levelLabel.text = "\(gameLogic.level)"
        
        if scene.tickLengthMillisec >= 100 {
            scene.tickLengthMillisec -= 100
        } else if scene.tickLengthMillisec > 50 {
            scene.tickLengthMillisec -= 50
        }
        scene.playSound(sound: "levelup.mp3")
    }
    
    func gameShapeDidDrop(gameLogic: GameLogic) {
        scene.stopTimer()
        scene.redrawShape(shape: gameLogic.fallingShape!) {
            gameLogic.letShapeFall()
        }
        scene.playSound(sound: "drop.mp3")
    }
    
    func gameShapeDidLand(gameLogic: GameLogic) {
        scene.stopTimer()
        self.view.isUserInteractionEnabled = false
        let removedLines = gameLogic.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            self.scoreLabel.text = "\(gameLogic.score)"
            scene.animateCollapsingLines(linesToRemove: removedLines.linesRemoved, fallenBlocks: removedLines.fallenBlocks) {
                self.gameShapeDidLand(gameLogic: gameLogic)
            }
            scene.playSound(sound: "bomb.mp3")
        } else {
            nextShape()
        }
    }
    
    func gameShapeDidMove(gameLogic: GameLogic) {
        scene.redrawShape(shape: gameLogic.fallingShape!) {}
    }
}
