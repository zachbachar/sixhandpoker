//
//  MenuAnimations.swift
//  SixHandPoker
//
//  Created by Zach Bachar on 29/11/2017.
//  Copyright © 2017 zach bachar. All rights reserved.
//

import UIKit
import SpriteKit

extension MenuScene{
    
    func animateMenuScene(){
        let scroll = childNode(withName: "scroll")!
        let title = childNode(withName: "title")!
        let startBtn = childNode(withName: "startBtn")!
        let optionsBtn = childNode(withName: "optionsBtn")!
        let tutorialBtn = childNode(withName: "tutorialBtn")!
        
        let fallIn = SKAction.group([SKAction.fadeAlpha(to: 1, duration: 0.3), SKAction.scaleX(to: 0.4, duration: 0.3), SKAction.scaleY(to: 0.4, duration: 0.3)])
        
        let remove = SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()])
        let bigSpark = SKEmitterNode(fileNamed: "BigSpark")!
        let titleFallIn = SKAction.sequence([SKAction.wait(forDuration: 1), fallIn])
        let smallSpark = SKEmitterNode(fileNamed: "SmallSpark")!
        
        bigSpark.position = scroll.position
        bigSpark.zPosition = 1
        smallSpark.position = title.position
        smallSpark.zPosition = 3
        
        scroll.run(fallIn, completion: {
            self.run(SKAction.playSoundFileNamed("falling", waitForCompletion: false))
            self.addChild(bigSpark)
            bigSpark.run(remove)
        })
        
        title.run(titleFallIn, completion: {
            self.run(SKAction.playSoundFileNamed("falling", waitForCompletion: false))
            self.addChild(smallSpark)
            smallSpark.run(remove)
        })
        
        startBtn.xScale = 1.5
        startBtn.yScale = 1.5
        optionsBtn.xScale = 1.5
        optionsBtn.yScale = 1.5
        tutorialBtn.xScale = 1.5
        tutorialBtn.yScale = 1.5
        
        startBtn.run(SKAction.sequence([SKAction.wait(forDuration: 1.3), buttonsFall()]))
        optionsBtn.run(SKAction.sequence([SKAction.wait(forDuration: 1.5), buttonsFall()]))
        tutorialBtn.run(SKAction.sequence([SKAction.wait(forDuration: 1.7), buttonsFall()]))
        
    }
    
    func buttonsFall() -> SKAction{
        let fallIn = SKAction.group([SKAction.fadeAlpha(to: 1, duration: 0.3), SKAction.scaleX(to: 0.3, duration: 0.3), SKAction.scaleY(to: 0.3, duration: 0.3)])
        let littleJump = SKAction.group([SKAction.scaleX(to: 0.4, duration: 0.3), SKAction.scaleY(to: 0.4, duration: 0.3), SKAction.playSoundFileNamed("chipsStack4", waitForCompletion: false)])
        let backInPlace = SKAction.group([SKAction.scaleX(to: 0.3, duration: 0.3), SKAction.scaleY(to: 0.3, duration: 0.3)])
        let sequence = SKAction.sequence([fallIn, littleJump, backInPlace])
        return sequence
    }
}
