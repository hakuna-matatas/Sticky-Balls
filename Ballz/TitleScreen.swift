//
//  TitleScreen.swift
//  Ballz
//
//  Created by Alan Gao on 7/7/16.
//  Copyright © 2016 Alan Gao. All rights reserved.
//

import Foundation

import SpriteKit

class TitleScreen: SKScene {
    
    /* UI Connections */
    var buttonPlay: MSButtonNode!
    
    
    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        /* Play SFX */
        let titleScreenSFX = SKAction.playSoundFileNamed("TitlescreenMusic", waitForCompletion: true)
        
        self.runAction(SKAction.repeatActionForever(titleScreenSFX))
        
        /* Set UI connections */
        buttonPlay = self.childNodeWithName("buttonPlay") as! MSButtonNode

        /* Setup restart button selection handler */
        buttonPlay.selectedHandler = {

            /* Grab reference to our SpriteKit view */
            let skView = self.view as SKView!
            
            /* Load Game scene */
            let scene = GameScene(fileNamed:"GameScene") as GameScene!
            
            /* Ensure correct aspect mode */
            scene.scaleMode = .AspectFill
            scene.removeAllActions()
//            /* Show debug */
//            skView.showsPhysics = true
//            skView.showsDrawCount = true
//            skView.showsFPS = true
            
            /* Button sound */
            let buttonSound = SKAction.playSoundFileNamed("playbuttonSound", waitForCompletion: false)
            self.runAction(buttonSound )

            self.runAfterDelay(0.5) {
                 /* Start game scene */
                skView.presentScene(scene)
            }
        }
    }
}