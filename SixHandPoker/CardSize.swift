//
//  CardSize.swift
//  SixHandPoker
//
//  Created by Zach Bachar on 29/11/2017.
//  Copyright © 2017 zach bachar. All rights reserved.
//

import UIKit
import SpriteKit

extension GameScene{
    
    func increaseHandSize(_ h:(Hand, Player)){
        let hand = h.0
        let player = h.1
        
        if player.name == "User" && round%2 != 0{
            hand.canThrow = true
            hand.isBig = true
            hand.card1.zPosition = 3
            hand.card2.zPosition = 4
            hand.card1.run(SKAction.group([SKAction.scale(by: 1.25, duration: 0.2)]))
            hand.card2.run(SKAction.group([SKAction.scale(by: 1.25, duration: 0.2)]))
        }
        else if player.name == "Opponent" && round%2 != 0{
            hand.canThrow = true
            hand.isBig = true
            hand.card1.zPosition = 4
            hand.card2.zPosition = 3
            hand.card1.run(SKAction.group([SKAction.scale(by: 1.25, duration: 0.2)]))
            hand.card2.run(SKAction.group([SKAction.scale(by: 1.25, duration: 0.2)]))
        }
        else if player.name == "Dealer" && round%2 == 0{
            hand.canThrow = true
            hand.isBig = true
            hand.card1.zPosition = 3
            hand.card2.zPosition = 4
            hand.card1.run(SKAction.group([SKAction.scale(by: 1.25, duration: 0.2)]))
            hand.card2.run(SKAction.group([SKAction.scale(by: 1.25, duration: 0.2)]))
        }
    }
    
    func decreaseHandSize(_ h:(Hand, Player)) {
        let hand = h.0
        let player = h.1
        
        if hand.isBig{
            if player.name == "User" && round%2 != 0{
                hand.canThrow = false
                hand.isBig = false
                hand.card1.zPosition = 1
                hand.card2.zPosition = 2
                hand.card1.run(SKAction.group([SKAction.scale(by: 0.8, duration: 0.2)]))
                hand.card2.run(SKAction.group([SKAction.scale(by: 0.8, duration: 0.2)]))
                
            }
            else if player.name == "Opponent" && round%2 != 0{
                hand.canThrow = false
                hand.isBig = false
                hand.card1.zPosition = 2
                hand.card2.zPosition = 1
                hand.card1.run(SKAction.group([SKAction.scale(by: 0.8, duration: 0.2)]))
                hand.card2.run(SKAction.group([SKAction.scale(by: 0.8, duration: 0.2)]))
            }
            else if player.name == "Dealer" && round%2 == 0{
                hand.canThrow = false
                hand.isBig = false
                hand.card1.zPosition = 1
                hand.card2.zPosition = 2
                hand.card1.run(SKAction.group([SKAction.scale(by: 0.8, duration: 0.2)]))
                hand.card2.run(SKAction.group([SKAction.scale(by: 0.8, duration: 0.2)]))
            }
            
        }
    }
}
