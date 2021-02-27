//
//  FirstDraw.swift
//  SixHandPoker
//
//  Created by Zach Bachar on 29/11/2017.
//  Copyright © 2017 zach bachar. All rights reserved.
//

import Foundation

import UIKit
import SpriteKit

extension GameScene{
    func initFirstDraw(){
        var positionX:CGFloat = 100
        let positionYuser:CGFloat = 200
        let positionYopp:CGFloat = 600
        
        let positionYtable:CGFloat = 400
        var positionXtable:CGFloat = 250
        
        let actionQ = ActionQ()
        
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi*2), duration: 0.2)
        let duration = 0.2
        
        for i in 0..<6{
            let n1 = user.hands[i].card1
            n1?.position = CGPoint(x: 300, y: 1200)
            n1?.zPosition = 1
            n1?.xScale = 0.65
            n1?.yScale = 0.65
            addChild(n1!)
            let pos1 = SKAction.move(to: CGPoint(x: positionX, y: positionYuser), duration: duration)
            let g1 = SKAction.group([pos1, rotate, drawCardSound()])
            actionQ.addNext(n1!, action: g1)
            
            let n3 = opponent.hands[i].card1
            n3?.position = CGPoint(x: 300, y: 1200)
            n3?.zRotation = CGFloat(Double.pi)
            n3?.zPosition = 2
            n3?.xScale = 0.65
            n3?.yScale = 0.65
            addChild(n3!)
            let pos2 = SKAction.move(to: CGPoint(x: positionX, y: positionYopp), duration: duration)
            let g2 = SKAction.group([pos2, rotate, drawCardSound()])
            actionQ.addNext(n3!, action: g2)
            
            let n2 = user.hands[i].card2
            n2?.position = CGPoint(x: 300, y: 1200)
            n2?.zPosition = 2
            n2?.xScale = 0.65
            n2?.yScale = 0.65
            addChild(n2!)
            let pos3 = SKAction.move(to: CGPoint(x: positionX + 30, y: positionYuser), duration: duration)
            let g3 = SKAction.group([pos3, rotate, drawCardSound()])
            actionQ.addNext(n2!, action: g3)
            
            let n4 = opponent.hands[i].card2
            n4?.position = CGPoint(x: 300, y: 1200)
            n4?.zRotation = CGFloat(Double.pi)
            n4?.zPosition = 1
            n4?.xScale = 0.65
            n4?.yScale = 0.65
            addChild(n4!)
            let pos4 = SKAction.move(to: CGPoint(x: positionX + 30, y: positionYopp), duration: duration)
            let g4 = SKAction.group([pos4, rotate, drawCardSound()])
            actionQ.addNext(n4!, action: g4)
            
            positionX += 130
        }
        
        for card in cardsOnTable{
            card.position = CGPoint(x: 300, y: 1200)
            card.texture = card.backTexture
            card.faceUp = false
            card.zPosition = 1
            addChild(card)
            let pos = SKAction.move(to: CGPoint(x: positionXtable, y: positionYtable), duration: duration)
            let g = SKAction.group([pos, rotate, drawCardSound()])
            actionQ.addNext(card, action: g)
            actionQ.addNext(self, action: drawCardSound())
            positionXtable += 120
            if card == cardsOnTable.last{
                cardsOnTable.first?.flip(7, complition: {
                    self.canPlay = true
                    self.round = 1
                    self.roundLabel("Round One")
                    print("table: " + self.cardsOnTable.description)
                })
            }
        }
    }
}
