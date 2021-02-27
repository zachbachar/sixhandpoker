//
//  Label.swift
//  SixHandPoker
//
//  Created by Zach Bachar on 29/11/2017.
//  Copyright © 2017 zach bachar. All rights reserved.
//

import UIKit
import SpriteKit

extension GameScene{
    
    func roundLabel(_ text:String){
        let label = SKLabelNode(fontNamed:"DayPosterBlackNF")
        label.text = text
        label.fontColor = UIColor.white
        label.fontSize = 45
        label.position.x = midX
        label.position.y = midY - label.frame.height*3
        label.zPosition = 5
        addChild(label)
        
        let upsideLabel = SKLabelNode(fontNamed:"DayPosterBlackNF")
        upsideLabel.position.x = midX
        upsideLabel.zRotation = CGFloat(Double.pi)
        upsideLabel.text = text
        upsideLabel.fontColor = UIColor.white
        upsideLabel.fontSize = 45
        upsideLabel.position.y = midY + upsideLabel.frame.height*3.8
        upsideLabel.zPosition = 5
        addChild(upsideLabel)
        
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        label.run(fadeIn, completion: {
            label.run(SKAction.sequence([SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()]))
        })
        upsideLabel.run(fadeIn, completion: {
            upsideLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()]))
        })
        
        let smoke = SKEmitterNode(fileNamed: "Smoke")!
        smoke.position = label.position
        smoke.zPosition = 6
        
        let upsideSmoke = SKEmitterNode(fileNamed: "Smoke")!
        upsideSmoke.position = upsideLabel.position
        upsideSmoke.zRotation = CGFloat(Double.pi)
        upsideSmoke.zPosition = 6
        
        let remove = SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
        addChild(smoke)
        addChild(upsideSmoke)
        smoke.run(remove)
        upsideSmoke.run(remove)
    }
}
