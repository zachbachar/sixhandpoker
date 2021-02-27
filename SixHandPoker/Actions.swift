//
//  Actions.swift
//  SixHandPoker
//
//  Created by zach bachar on 05/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import UIKit
import SpriteKit

extension GameScene{
    
    func addNewGameButton(){
        let newGameBtn = SKSpriteNode(imageNamed: "startBtn")
        newGameBtn.zPosition = 6
        newGameBtn.xScale = 0.3
        newGameBtn.yScale = 0.3
        newGameBtn.position = CGPoint(x: midX+425 , y: midY+310)
        newGameBtn.alpha = 0
        newGameBtn.name = "newGameBtn"
        addChild(newGameBtn)
        
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi*2), duration: 2)
        let group = SKAction.group([fadeIn, SKAction.repeatForever(rotate)])
        newGameBtn.run(group)
    }
    
    func addMenuBtn(){
        let menuBtn = SKSpriteNode(imageNamed: "menuBtn")
        menuBtn.name = "menuBtn"
        menuBtn.alpha = 1
        menuBtn.xScale = 0.25
        menuBtn.yScale = 0.25
        menuBtn.zPosition = 6
        menuBtn.position = CGPoint(x: 80, y: self.frame.height-80)
        addChild(menuBtn)
        
        let fadeIn = SKAction.fadeAlpha(to: 1, duration: 1)
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi*2), duration: 2)
        let group = SKAction.group([fadeIn, SKAction.repeatForever(rotate)])
        menuBtn.run(group)
    }
    
    func clearTable(){
        let actionQ = ActionQ()
        
        let moveToCenter = SKAction.move(to: CGPoint(x: midX, y: midY), duration: 0.3)
        let getherAll = SKAction.group([moveToCenter, SKAction.rotate(toAngle: CGFloat(Double.pi*2), duration: 0.3)])
        let group = SKAction.sequence([getherAll, slideSound(), SKAction.removeFromParent()])
        
        for card in cardsOnTable{
            card.run(group)
        }
        
         user.hands.first!.card1.run(group)
         user.hands.first!.card2.run(group)
         opponent.hands.first!.card1.run(group)
         opponent.hands.first!.card2.run(group)
         dealer.hands.first!.card1.run(group)
         dealer.hands.first!.card2.run(group)
        
        let magic = SKEmitterNode(fileNamed: "Magic")!
        magic.position = CGPoint(x: midX, y: midY)
        magic.zPosition = 6
        magic.particleTexture = cardsOnTable.last!.frontTexture
        let removeMagic = SKAction.sequence([
            SKAction.playSoundFileNamed("cardFan2", waitForCompletion: false),
            SKAction.fadeOut(withDuration: 1),
            SKAction.removeFromParent()
            ])
        addChild(magic)
        magic.run(removeMagic)
        
        let btn = childNode(withName: "newGameBtn")!
        actionQ.addNext(btn, action: SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent(),
            SKAction.wait(forDuration: actionQ.timeLeftInQ*2),
            resetGame()
            ]))
      
        removeAllNodes()
    }
    
    func removeAllNodes(){
        childNode(withName: "label")?.removeFromParent()
        childNode(withName: "upsideLabel")?.removeFromParent()
        childNode(withName: "upsideSmoke")?.removeFromParent()
        childNode(withName: "smoke")?.removeFromParent()
        childNode(withName: "winnerLabel")?.removeFromParent()
        childNode(withName: "winner")?.removeFromParent()
        childNode(withName: "menuBtn")?.removeFromParent()
    }
}


