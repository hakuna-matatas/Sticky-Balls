//
//  GameScene.swift
//  Ballz
//
//  Created by Alan Gao on 7/5/16.
//  Copyright (c) 2016 Alan Gao. All rights reserved.
//

import SpriteKit

enum GameState {
    case Playing, GameOver
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var timer: NSTimer?
    var timerRunning = false
    var funnel: Funnel!
    var innerCircle: SKSpriteNode!
    //TODO: IMPLEMENT BOUNDARY
    var boundary: SKSpriteNode!
    /* Used to create other Ball objects by the .copy() method */
    var genericBall: Ball!
    /* Stores all balls in the funnel */
    var ballsInFunnel: [Ball] = []
    /* Stores balls that left the funnel */
    var gameBalls: [Ball] = []

    var objectsToRemove = [Ball]()
    
    var gameState: GameState = .Playing
    var scoreLabel: SKLabelNode!
    
    /* How fast the mill rotates */
    var rotationSpeed = CGFloat(0.02)
    var completedMerges = 0 {
        didSet {
            scoreLabel.text = String(completedMerges*100)
        }
    }
    
    /* The position of the bottom most ball on the funnel */
    let LAST_BALL_POSITION = CGPoint(x: 187.5, y: 550.5)
    /* The distance the next ball will spawn above the one below it*/
    let BALL_INCREMENT = CGPoint(x: 0, y: 35)
    let TIMER_LENGTH = 0.5
    
    /* health bar */
    var lifebar: SKSpriteNode!
    
    var life: CGFloat = 1.0 {
        didSet {
            /* Scale health bar between 0.0 -> 1.0 e.g 0 -> 100% */
            lifebar.xScale = life
        }
    }

    override func didMoveToView(view: SKView) {
        /* connect lifebar */
        lifebar = childNodeWithName("lifebar") as! SKSpriteNode
        
        /* Set physics world delegate */
        physicsWorld.contactDelegate = self

        initializeVars()
        ballsInFunnel.append(genericBall)
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        addRandomBalls(4)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if(gameState == .GameOver || timerRunning) { return }
        
        /* play ball dropping SFX */
        let droppingSound = SKAction.playSoundFileNamed("dropping bubbles", waitForCompletion: false)
        self.runAction(droppingSound)
        
        timerRunning = true
        timer = NSTimer.scheduledTimerWithTimeInterval(TIMER_LENGTH, target: self, selector: (#selector(GameScene.stopTimer)), userInfo: nil, repeats: false)
        
        let droppedBall = ballsInFunnel[0]
        
        /* To drop the ball from funnel, we change the ball's collision bit mask */
        droppedBall.physicsBody?.collisionBitMask = PhysicsCategory.InnerCircle | PhysicsCategory.Ball
        /* Now that the ball has dropped, we care about what the ball contacts */
        droppedBall.physicsBody?.contactTestBitMask = PhysicsCategory.InnerCircle | PhysicsCategory.Ball
        
        gameBalls.append(droppedBall)
        ballsInFunnel.removeAtIndex(0)
        addRandomBalls(1)
    }
   
    override func update(currentTime: CFTimeInterval) {
        if(gameState == .GameOver) { return }
        
        rotationSpeed += 0.000007
        
        innerCircle.zRotation += rotationSpeed
        
        life -= 0.0005
        
        if(life <= 0) { gameOver() }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timerRunning = false
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let ballA = contact.bodyA.node as? Ball
        let ballB = contact.bodyB.node as? Ball
        var fallingBall: Ball!
        
        if(ballA != nil && ballA?.isConnected == false) {
            fallingBall = ballA
        }
        else {
            fallingBall = ballB
        }
        
        let ANCHOR_POINT = contact.contactPoint
        let joint = SKPhysicsJointFixed.jointWithBodyA(fallingBall!.physicsBody!, bodyB: innerCircle.physicsBody!, anchor: ANCHOR_POINT)
        self.physicsWorld.addJoint(joint)
    
        Ball.findBallNeighbours(gameBalls)
        objectsToRemove = Ball.checkForThreeInARow(gameBalls)
        
        fallingBall.isConnected = true
        /* Must remove collision properties or ball may continue to make an obscene number of joints */
        fallingBall.removeCollisions()
    }

    override func didSimulatePhysics() {
        for obj in objectsToRemove {
            obj.removeFromParent()
            if let index = gameBalls.indexOf(obj) {
                gameBalls.removeAtIndex(index)
                
                /* play combo SFX */
                let bubbleCombo = SKAction.playSoundFileNamed("bubblecombo", waitForCompletion: false)
                self.runAction(bubbleCombo)
            }
        }
        objectsToRemove.removeAll()
    }
    
    func addRandomBalls(nTimes: Int) {
        for _ in 0 ..< nTimes {
            let newBall = ballsInFunnel.last!.copy() as! Ball
            
            newBall.position.y += BALL_INCREMENT.y
            newBall.texture = SKTexture(imageNamed: newBall.randomizeColor().rawValue)
            
            let physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(14))
            newBall.physicsBody = physicsBody
            
            self.addChild(newBall)
            ballsInFunnel.append(newBall)
        }
    }
    
    func gameOver() {
        gameState = .GameOver
        self.removeAllActions()
        innerCircle.physicsBody?.affectedByGravity = true
        
        /* play gameover SFX */
        let gameOverSound = SKAction.playSoundFileNamed("gameover (1)", waitForCompletion: false)
        self.runAction(gameOverSound)
                
    }
    
    func initializeVars() {
        innerCircle = self.childNodeWithName("innerCircle") as! SKSpriteNode
        genericBall = self.childNodeWithName("genericBall") as! Ball
        boundary = self.childNodeWithName("boundary") as! SKSpriteNode
        scoreLabel = self.childNodeWithName("scoreLabel") as! SKLabelNode
        
        funnel = Funnel()
        funnel.position = CGPoint(x: self.frame.width/2 - 18, y: 587)
        self.addChild(funnel)
        
        /* Physics contact is two ways - i.e. ball hits circle and circle hits ball
           We only need to consider whether the ball hit the circle and not the other way around
           Therefore, the circle's collision and contact mask are both 0 (None) */
        innerCircle.physicsBody?.categoryBitMask = PhysicsCategory.InnerCircle
        innerCircle.physicsBody?.collisionBitMask = PhysicsCategory.None
        innerCircle.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        genericBall.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        genericBall.physicsBody?.collisionBitMask = PhysicsCategory.Ball | PhysicsCategory.Funnel
        genericBall.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
        funnel.physicsBody?.categoryBitMask = PhysicsCategory.Funnel
        funnel.physicsBody?.collisionBitMask = PhysicsCategory.Ball
        funnel.physicsBody?.contactTestBitMask = PhysicsCategory.None
        
    }
}

