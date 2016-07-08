//
//  Ball.swift
//  Ballz
//
//  Created by Alan Gao on 7/5/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import SpriteKit
import Darwin  //Random num generator

enum Color: String
{
    case Blue = "Blue Ball"
    case Red = "Red Ball"
    case Yellow = "Yellow Ball"
    case Green = "Green Ball"
    case Black = "Black Ball"
    case Rainbow = "Rainbow Ball"
}

class Ball: SKSpriteNode {
    
    var isConnected = false
    var ballColor: Color = .Green   //First ball is green
    
    func removeCollisions() {
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.contactTestBitMask = PhysicsCategory.None
    }
    
    func randomizeColor() -> Color {
        let randNum = arc4random_uniform(100)   //rand num from 0-99
        let newBallColor: Color
        
        if(randNum < 25) {
            newBallColor = .Blue
        }
        else if(randNum < 50) {
            newBallColor = .Green
        }
        else if (randNum < 75) {
            newBallColor = .Red
        }
        else {
            newBallColor = .Yellow
        }
        ballColor = newBallColor
        return newBallColor
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
