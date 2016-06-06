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
    
    func initFirstDraw(){
        let playerZone = childNodeWithName("playerZone")!
        let opponentZone = childNodeWithName("opponentZone")!
        let dealerZone = childNodeWithName("dealerZone")!
        let tableCardsZone = childNodeWithName("tableCardZone")!
        
        var positionX:CGFloat = 100
        let positionYuser:CGFloat = 200
        let positionYopp:CGFloat = 600
        
        let positionYtable:CGFloat = 400
        var positionXtable:CGFloat = 250
        
        let actionQ = ActionQ()
        
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI*2), duration: 0.3)
        
        for i in 0..<6{
            let n1 = user.hands[i].card1
            n1.position = CGPointMake(300, 1200)
            n1.zPosition = 0
            //n1.xScale = 0.7
            //n1.yScale = 0.7
            addChild(n1)
            let pos1 = SKAction.moveTo(CGPointMake(positionX, positionYuser), duration: 0.3)
            let g1 = SKAction.group([pos1, rotate])
            actionQ.addNext(n1, action: g1)
            
            let n3 = opponent.hands[i].card1
            n3.position = CGPointMake(300, 1200)
            n3.zRotation = CGFloat(M_PI)
            n3.zPosition = 15
            //n3.xScale = 0.7
            //n3.yScale = 0.7
            addChild(n3)
            let pos2 = SKAction.moveTo(CGPointMake(positionX, positionYopp), duration: 0.3)
            let g2 = SKAction.group([pos2, rotate])
            actionQ.addNext(n3, action: g2)
            
            let n2 = user.hands[i].card2
            n2.position = CGPointMake(300, 1200)
            n2.zPosition = 15
            //n2.xScale = 0.7
            //n2.yScale = 0.7
            addChild(n2)
            let pos3 = SKAction.moveTo(CGPointMake(positionX + 30, positionYuser), duration: 0.3)
            let g3 = SKAction.group([pos3, rotate])
            actionQ.addNext(n2, action: g3)
            
            let n4 = opponent.hands[i].card2
            n4.position = CGPointMake(300, 1200)
            n4.zRotation = CGFloat(M_PI)
            n4.zPosition = 0
            //n4.xScale = 0.7
            //n4.yScale = 0.7
            addChild(n4)
            let pos4 = SKAction.moveTo(CGPointMake(positionX + 30, positionYopp), duration: 0.3)
            let g4 = SKAction.group([pos4, rotate])
            actionQ.addNext(n4, action: g4)
            
            positionX += 130
        }
        
        for card in cardsOnTable{
            card.position = CGPointMake(300, 1200)
            card.texture = card.backTexture
            card.faceUp = false
            addChild(card)
            let pos = SKAction.moveTo(CGPointMake(positionXtable, positionYtable), duration: 0.3)
            let g = SKAction.group([pos, rotate])
            actionQ.addNext(card, action: g)
            positionXtable += 120
            if card == cardsOnTable.last{
                cardsOnTable.first?.flip(10, complition: {
                    self.canPlay = true
                    self.round = 1
                    print("round one")
                })
            }
        }
    }
    
    func dissmissHand(hand:Hand){
        let throwOut = SKAction.moveTo(CGPointMake(1000, 1000), duration: 0.5)
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 0.5)
        
        hand.card1.runAction(throwOut)
        hand.card1.runAction(rotate)
        hand.card2.runAction(throwOut)
        hand.card2.runAction(rotate)
        
        dealer.removeHand(hand: hand)
        print("dealer hands: \(dealer.hands.count)")
    }
    
    func moveToDealer(hand:Hand, player:Player){
        let c1Position = dealerPositions[dealer.hands.count]
        var c2Position = dealerPositions[dealer.hands.count]
        c2Position.y += 30
        
        let moveC1 = SKAction.moveTo(c1Position, duration: 0.5)
        let moveC2 = SKAction.moveTo(c2Position, duration: 0.5)
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 0.5)
        
        
        hand.card1.runAction(moveC1) {
            hand.card1.zRotation = CGFloat(M_PI_2)
        }
        hand.card1.runAction(rotate)
        
        hand.card2.runAction(moveC2) {
            hand.card2.zRotation = CGFloat(M_PI_2)
        }
        hand.card2.runAction(rotate)
        
        player.removeHand(hand: hand)
        dealer.hands.append(hand)
        print(dealer.hands.count)
    }
    
    func rearrangeCardsAtDealer(){
        for i in 0...dealer.hands.count - 1{
            let c1Position = dealerPositions[i]
            var c2Position = dealerPositions[i]
            c2Position.y += 30
            
            dealer.hands[i].card1.runAction(SKAction.moveTo(c1Position, duration: 0.2))
            dealer.hands[i].card2.runAction(SKAction.moveTo(c2Position, duration: 0.2))
            
            dealer.hands[i].card2.zPosition = 50
        }
    }
    
    

}