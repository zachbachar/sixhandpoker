//
//  MenuScene.swift
//  SixHandPoker
//
//  Created by zach bachar on 08/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {

    var midX = CGFloat()
    var midY = CGFloat()
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        midX = CGRectGetMidX(self.frame)
        midY = CGRectGetMidY(self.frame)
        addScroll()
        addTitle()
        addButtons()
        animateMenuScene()
    }
    
    func addScroll(){
        let scroll = SKSpriteNode(imageNamed: "scroll")
        scroll.name = "scroll"
        //scroll.xScale = 0.4
        //scroll.yScale = 0.4
        scroll.alpha = 0
        scroll.position = CGPoint(x: midX, y: midY + 150)
        scroll.zPosition = 2
        addChild(scroll)
    }
    
    func addTitle(){
        let title = SKSpriteNode(imageNamed: "title")
        title.name = "title"
        //title.xScale = 0.4
        //title.yScale = 0.4
        title.alpha = 0
        title.position = CGPoint(x: midX, y: midY + 150)
        title.zPosition = 4
        addChild(title)
    }
    
    func addButtons(){
        let startBtn = SKSpriteNode(imageNamed: "startBtn")
        startBtn.name = "startBtn"
        startBtn.xScale = 0.35
        startBtn.yScale = 0.35
        startBtn.alpha = 0
        startBtn.zPosition = 2
        startBtn.position = CGPoint(x: midX, y: midY - 250)
        addChild(startBtn)
        
        let optionsBtn = SKSpriteNode(imageNamed: "optionsBtn")
        optionsBtn.name = "optionsBtn"
        optionsBtn.xScale = 0.3
        optionsBtn.yScale = 0.3
        optionsBtn.alpha = 0
        optionsBtn.zPosition = 2
        optionsBtn.position = CGPoint(x: midX - startBtn.frame.width, y: midY - 250)
        addChild(optionsBtn)
        
        let tutorialBtn = SKSpriteNode(imageNamed: "tutorialBtn")
        tutorialBtn.name = "tutorialBtn"
        tutorialBtn.xScale = 0.3
        tutorialBtn.yScale = 0.3
        tutorialBtn.alpha = 0
        tutorialBtn.zPosition = 2
        tutorialBtn.position = CGPoint(x: midX + startBtn.frame.width, y: midY - 250)
        addChild(tutorialBtn)
    }
    
    func animateMenuScene(){
        let scroll = childNodeWithName("scroll")!
        let title = childNodeWithName("title")!
        let startBtn = childNodeWithName("startBtn")!
        let optionsBtn = childNodeWithName("optionsBtn")!
        let tutorialBtn = childNodeWithName("tutorialBtn")!
        
        let fallIn = SKAction.group([SKAction.fadeAlphaTo(1, duration: 0.3), SKAction.scaleXTo(0.4, duration: 0.3), SKAction.scaleYTo(0.4, duration: 0.3)])
        
        let remove = SKAction.sequence([SKAction.fadeOutWithDuration(0.5), SKAction.removeFromParent()])
        let bigSpark = SKEmitterNode(fileNamed: "BigSpark")!
        let titleFallIn = SKAction.sequence([SKAction.waitForDuration(1), fallIn])
        let smallSpark = SKEmitterNode(fileNamed: "SmallSpark")!
        
        bigSpark.position = scroll.position
        bigSpark.zPosition = 1
        smallSpark.position = title.position
        smallSpark.zPosition = 3
        
        scroll.runAction(fallIn){
            self.runAction(SKAction.playSoundFileNamed("falling", waitForCompletion: false))
            self.addChild(bigSpark)
            bigSpark.runAction(remove)
        }
        
        title.runAction(titleFallIn){
            self.runAction(SKAction.playSoundFileNamed("falling", waitForCompletion: false))
            self.addChild(smallSpark)
            smallSpark.runAction(remove)
        }
        
        startBtn.xScale = 1.5
        startBtn.yScale = 1.5
        optionsBtn.xScale = 1.5
        optionsBtn.yScale = 1.5
        tutorialBtn.xScale = 1.5
        tutorialBtn.yScale = 1.5
        
        startBtn.runAction(SKAction.sequence([SKAction.waitForDuration(1.3), buttonsFall()]))
        optionsBtn.runAction(SKAction.sequence([SKAction.waitForDuration(1.5), buttonsFall()]))
        tutorialBtn.runAction(SKAction.sequence([SKAction.waitForDuration(1.7), buttonsFall()]))
        
    }
    
    func buttonsFall() -> SKAction{
        let fallIn = SKAction.group([SKAction.fadeAlphaTo(1, duration: 0.3), SKAction.scaleXTo(0.3, duration: 0.3), SKAction.scaleYTo(0.3, duration: 0.3)])
        let littleJump = SKAction.group([SKAction.scaleXTo(0.4, duration: 0.3), SKAction.scaleYTo(0.4, duration: 0.3), SKAction.playSoundFileNamed("chipsStack4", waitForCompletion: false)])
        let backInPlace = SKAction.group([SKAction.scaleXTo(0.3, duration: 0.3), SKAction.scaleYTo(0.3, duration: 0.3)])
        let sequence = SKAction.sequence([fallIn, littleJump, backInPlace])
        return sequence
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let location = touch.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        if touchedNode.name == "startBtn"{
            moveToGameScene()
        }
    }
    
    func moveToGameScene(){
        let chip = childNodeWithName("startBtn")!
        let flyAway = SKAction.group([SKAction.moveToY((view?.frame.height)!+100, duration: 0.15), SKAction.repeatAction(SKAction.rotateByAngle(CGFloat(M_PI*2), duration: 0.15), count: 2)])
        let bounce = SKAction.sequence([SKAction.scaleBy(1.25, duration: 0.05), SKAction.scaleBy(0.8, duration: 0.05), flyAway])
        let gameScene = GameScene(fileNamed:"GameScene")!
        let transition = SKTransition.crossFadeWithDuration(0.5)
        chip.runAction(SKAction.group([bounce, SKAction.playSoundFileNamed("cardFan2", waitForCompletion: false)])){
            self.view?.presentScene(gameScene, transition: transition)
        }
    }
}
