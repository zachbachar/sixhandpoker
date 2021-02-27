//
//  DealerActions.swift
//  SixHandPoker
//
//  Created by Zach Bachar on 29/11/2017.
//  Copyright © 2017 zach bachar. All rights reserved.
//

import UIKit
import SpriteKit

extension GameScene{
    
    func dissmissHand(_ hand:Hand){
        let throwOut = SKAction.move(to: CGPoint(x: 1000, y: 1000), duration: 0.5)
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.3)
        
        run(slideSound())
        hand.card1.run(throwOut)
        hand.card1.run(rotate)
        hand.card2.run(throwOut)
        hand.card2.run(rotate)
        
        var _ = dealer.removeHand(hand: hand)
    }
    
    func moveToDealer(_ hand:Hand, player:Player){
        let c1Position = dealerPositions[dealer.hands.count]
        var c2Position = dealerPositions[dealer.hands.count]
        c2Position.y += 30
        
        let moveC1 = SKAction.move(to: c1Position, duration: 0.5)
        let moveC2 = SKAction.move(to: c2Position, duration: 0.5)
        var rotate = SKAction.rotate(byAngle: 0, duration: 0)
        switch player.name {
        case "User":
            //rotate = SKAction.rotate(byAngle: CGFloat(Double.pi*2.5), duration: 0.5)
            rotate = SKAction.rotate(toAngle: CGFloat(Double.pi/2), duration: 0.5)
            break
        case "Opponent":
            rotate = SKAction.rotate(toAngle: CGFloat(Double.pi/2), duration: 0.5)
            break
        default:
            rotate = SKAction.rotate(toAngle: CGFloat(Double.pi/2), duration: 0.5)
        }
        
        
        self.run(slideSound())
        
        hand.card1.run(moveC1, completion: {
            hand.card1.zRotation = CGFloat(Double.pi/2)
            hand.card1.zPosition = 1
        })
        hand.card1.run(rotate)
        
        hand.card2.run(moveC2, completion: {
            hand.card2.zRotation = CGFloat(Double.pi/2)
            hand.card2.zPosition = 2
        })
        hand.card2.run(rotate)
        
        var _ = player.removeHand(hand: hand)
        dealer.hands.append(hand)
    }
    
    func rearrangeCardsAtDealer(){
        for i in 0...dealer.hands.count - 1{
            let c1Position = dealerPositions[i]
            var c2Position = dealerPositions[i]
            c2Position.y += 30
            
            dealer.hands[i].card1.run(SKAction.move(to: c1Position, duration: 0.2))
            dealer.hands[i].card2.run(SKAction.move(to: c2Position, duration: 0.2))
        }
    }
}
