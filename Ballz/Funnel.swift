////
////  Funnel.swift
////  Ballz
////
////  Created by Alan Gao on 7/7/16.
////  Copyright © 2016 Alan Gao. All rights reserved.
////
//
//import SpriteKit
//
//class Funnel: SKShapeNode {
//
//    
//    
//    override init() {
//
//        let path = UIBezierPath()
//        let startPoint = CGPoint(x: -200, y: 330)
//        path.moveToPoint(startPoint)
//        path.addLineToPoint(CGPoint(x: -20, y: 45))
//        path.addLineToPoint(CGPoint(x: 0, y: -55))
//        path.addLineToPoint(CGPoint(x: 40, y: -55))
//        path.addLineToPoint(CGPoint(x: 60, y: 45))
//        path.addLineToPoint(CGPoint(x: 240, y: 330))
//        
//        super.init(path: path.CGPath)
//        
//        self.position = CGPoint(x: self.frame.width/2 - 18, y: 587)
//        self.physicsBody = SKPhysicsBody(edgeChainFromPath: path.CGPath)
//        self.strokeColor = UIColor.darkGrayColor()
//        self.lineWidth = 4
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//}