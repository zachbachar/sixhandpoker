//
//  Sounds.swift
//  SixHandPoker
//
//  Created by Zach Bachar on 29/11/2017.
//  Copyright © 2017 zach bachar. All rights reserved.
//

import UIKit
import SpriteKit

extension GameScene{
   
    func drawCardSound() -> SKAction{
        let sounds = [
            SKAction.playSoundFileNamed("cardSlide1", waitForCompletion: false),SKAction.playSoundFileNamed("cardSlide2", waitForCompletion: false)]
        
        //slet rand = Int.nextRandom(upTo: sounds.count)
        
        return sounds[0]
    }
    
    func slideSound() -> SKAction{
        let sounds = [
            SKAction.playSoundFileNamed("cardShove1", waitForCompletion: false),
            SKAction.playSoundFileNamed("cardShove2", waitForCompletion: false),
            SKAction.playSoundFileNamed("cardShove3", waitForCompletion: false),
            SKAction.playSoundFileNamed("cardShove4", waitForCompletion: false)
        ]
        
        return sounds[Int.nextRandom(upTo: sounds.count)]
    }
}
