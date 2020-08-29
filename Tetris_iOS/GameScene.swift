//
//  GameScene.swift
//  Tetris_iOS
//
//  Created by Ryan Leung on 2020-08-29.
//  Copyright © 2020 Ryan Leung. All rights reserved.
//

import SpriteKit

let TickLengthLevelOne = TimeInterval(600)

class GameScene: SKScene {
    // tick is closure
    var tick:(() -> ())?
    var tickLengthMillisec = TickLengthLevelOne
    var lastTick:NSDate?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0, y: 1.0)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0, y: 0)
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        addChild(background)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        guard let lastTick = lastTick else {
            return
        }
        let timePassed = lastTick.timeIntervalSinceNow * -1000.0
        if timePassed > tickLengthMillisec {
            self.lastTick = NSDate()
            tick?()
        }
    }
    
    func startTimer() {
        lastTick = NSDate()
    }
    
    func stopTimer() {
        lastTick = nil
    }
}
