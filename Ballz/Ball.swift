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
}

class Ball: SKSpriteNode {
    
    var isConnected = false
    var hasNeighbourList = false
    var neighbours: [Ball] = []
    var ballColor: Color = .Green   //First ball is green
    
    static let LARGEST_DIST_BETWEEN_BALLS = CGFloat(45)
    
    static func findBallNeighbours(gameBalls: [Ball]) {
        for ball in gameBalls {
            for potentialNeighbour in gameBalls {
                let distance = ball.position.distanceFromCGPoint(potentialNeighbour.position)
                if(distance < self.LARGEST_DIST_BETWEEN_BALLS && distance != 0) {
                    ball.neighbours.append(potentialNeighbour)
                }
            }
        }
    }
    
    static func checkForThreeInARow(gameBalls: [Ball]) -> [Ball] {
        var objectsToRemove: [Ball] = []
        
        for ball in gameBalls {
            var toRemoveSublist: [Ball] = []
            
            for neighbour in ball.neighbours {
                if(neighbour.ballColor == ball.ballColor) {
                    toRemoveSublist.append(neighbour)
                }
            }
            if(toRemoveSublist.count >= 2) {
                objectsToRemove += toRemoveSublist
                objectsToRemove.append(ball)
            }
            ball.neighbours = []
        }
        
        return objectsToRemove
    }
    
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



extension CGPoint {
    func distanceFromCGPoint(point:CGPoint)->CGFloat{
        return sqrt(pow(self.x - point.x,2) + pow(self.y - point.y,2))
    }
}
