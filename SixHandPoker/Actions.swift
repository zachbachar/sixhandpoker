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
            n1.zPosition = 1
            n1.xScale = 0.65
            n1.yScale = 0.65
            addChild(n1)
            let pos1 = SKAction.moveTo(CGPointMake(positionX, positionYuser), duration: 0.3)
            let g1 = SKAction.group([pos1, rotate, drawCardSound()])
            actionQ.addNext(n1, action: g1)
            
            let n3 = opponent.hands[i].card1
            n3.position = CGPointMake(300, 1200)
            n3.zRotation = CGFloat(M_PI)
            n3.zPosition = 2
            n3.xScale = 0.65
            n3.yScale = 0.65
            addChild(n3)
            let pos2 = SKAction.moveTo(CGPointMake(positionX, positionYopp), duration: 0.3)
            let g2 = SKAction.group([pos2, rotate, drawCardSound()])
            actionQ.addNext(n3, action: g2)
            
            let n2 = user.hands[i].card2
            n2.position = CGPointMake(300, 1200)
            n2.zPosition = 2
            n2.xScale = 0.65
            n2.yScale = 0.65
            addChild(n2)
            let pos3 = SKAction.moveTo(CGPointMake(positionX + 30, positionYuser), duration: 0.3)
            let g3 = SKAction.group([pos3, rotate, drawCardSound()])
            actionQ.addNext(n2, action: g3)
            
            let n4 = opponent.hands[i].card2
            n4.position = CGPointMake(300, 1200)
            n4.zRotation = CGFloat(M_PI)
            n4.zPosition = 1
            n4.xScale = 0.65
            n4.yScale = 0.65
            addChild(n4)
            let pos4 = SKAction.moveTo(CGPointMake(positionX + 30, positionYopp), duration: 0.3)
            let g4 = SKAction.group([pos4, rotate, drawCardSound()])
            actionQ.addNext(n4, action: g4)
            
            positionX += 130
        }
        
        for card in cardsOnTable{
            card.position = CGPointMake(300, 1200)
            card.texture = card.backTexture
            card.faceUp = false
            card.zPosition = 1
            addChild(card)
            let pos = SKAction.moveTo(CGPointMake(positionXtable, positionYtable), duration: 0.3)
            let g = SKAction.group([pos, rotate, drawCardSound()])
            actionQ.addNext(card, action: g)
            actionQ.addNext(self, action: drawCardSound())
            positionXtable += 120
            if card == cardsOnTable.last{
                cardsOnTable.first?.flip(10, complition: {
                    self.canPlay = true
                    self.round = 1
                    self.roundLabel("Round One")
                })
            }
        }
    }
    
    func dissmissHand(hand:Hand){
        let throwOut = SKAction.moveTo(CGPointMake(1000, 1000), duration: 0.5)
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 0.5)
        
        runAction(slideSound())
        hand.card1.runAction(throwOut)
        hand.card1.runAction(rotate)
        hand.card2.runAction(throwOut)
        hand.card2.runAction(rotate)
        
        dealer.removeHand(hand: hand)
    }
    
    func moveToDealer(hand:Hand, player:Player){
        let c1Position = dealerPositions[dealer.hands.count]
        var c2Position = dealerPositions[dealer.hands.count]
        c2Position.y += 30
        
        let moveC1 = SKAction.moveTo(c1Position, duration: 0.5)
        let moveC2 = SKAction.moveTo(c2Position, duration: 0.5)
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 0.5)
        
        self.runAction(slideSound())
        
        hand.card1.runAction(moveC1) {
            hand.card1.zRotation = CGFloat(M_PI_2)
            hand.card1.zPosition = 1
        }
        hand.card1.runAction(rotate)
        
        hand.card2.runAction(moveC2) {
            hand.card2.zRotation = CGFloat(M_PI_2)
            hand.card2.zPosition = 2
        }
        hand.card2.runAction(rotate)
        
        player.removeHand(hand: hand)
        dealer.hands.append(hand)
    }
    
    func rearrangeCardsAtDealer(){
        for i in 0...dealer.hands.count - 1{
            let c1Position = dealerPositions[i]
            var c2Position = dealerPositions[i]
            c2Position.y += 30
            
            dealer.hands[i].card1.runAction(SKAction.moveTo(c1Position, duration: 0.2))
            dealer.hands[i].card2.runAction(SKAction.moveTo(c2Position, duration: 0.2))
        }
    }
    
    func drawCardSound() -> SKAction{
        let sounds = [
            SKAction.playSoundFileNamed("cardSlide1", waitForCompletion: false),SKAction.playSoundFileNamed("cardSlide2", waitForCompletion: false),   SKAction.playSoundFileNamed("cardPlace1", waitForCompletion: false)]
        
        let rand = Int.nextRandom(upTo: sounds.count)
        
        return sounds[rand]
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
    
    func addNewGameButton(){
        let newGameBtn = SKSpriteNode(imageNamed: "startBtn")
        newGameBtn.zPosition = 6
        newGameBtn.xScale = 0.3
        newGameBtn.yScale = 0.3
        newGameBtn.position = CGPoint(x: view!.frame.width - newGameBtn.frame.width, y: view!.frame.height - newGameBtn.frame.height)
        newGameBtn.alpha = 0
        newGameBtn.name = "newGameBtn"
        addChild(newGameBtn)
        
        let fadeIn = SKAction.fadeAlphaTo(1, duration: 1)
        let rotate = SKAction.rotateByAngle(CGFloat(M_PI*2), duration: 2)
        let group = SKAction.group([fadeIn, SKAction.repeatActionForever(rotate)])
        newGameBtn.runAction(group)
    }
    
    func clearTable(){
        let actionQ = ActionQ()
        
        let moveToCenter = SKAction.moveTo(CGPointMake(midX, midY), duration: 0.3)
        let getherAll = SKAction.group([moveToCenter, SKAction.rotateToAngle(CGFloat(M_PI*2), duration: 0.3)])
        let group = SKAction.sequence([getherAll, slideSound(), SKAction.removeFromParent()])
        
        for card in cardsOnTable{
            card.runAction(group)
        }
        
         user.hands.first!.card1.runAction(group)
         user.hands.first!.card2.runAction(group)
         opponent.hands.first!.card1.runAction(group)
         opponent.hands.first!.card2.runAction(group)
         dealer.hands.first!.card1.runAction(group)
         dealer.hands.first!.card2.runAction(group)
        
        let magic = SKEmitterNode(fileNamed: "Magic")!
        magic.position = CGPoint(x: midX, y: midY)
        magic.zPosition = 6
        magic.particleTexture = cardsOnTable.last!.frontTexture
        let removeMagic = SKAction.sequence([
            SKAction.playSoundFileNamed("cardFan2", waitForCompletion: false),
            SKAction.fadeOutWithDuration(1),
            SKAction.removeFromParent()
            ])
        addChild(magic)
        magic.runAction(removeMagic)
        
        let btn = childNodeWithName("newGameBtn")!
        actionQ.addNext(btn, action: SKAction.sequence([
            SKAction.waitForDuration(1),
            SKAction.fadeOutWithDuration(0.3),
            SKAction.removeFromParent(),
            SKAction.waitForDuration(actionQ.timeLeftInQ*2),
            resetGame()
            ]))
        
        childNodeWithName("label")?.removeFromParent()
        childNodeWithName("upsideLabel")?.removeFromParent()
        childNodeWithName("upsideSmoke")?.removeFromParent()
        childNodeWithName("smoke")?.removeFromParent()
    }
    
    func roundLabel(text:String){
        let label = SKLabelNode(fontNamed:"American Typewriter")
        label.text = text
        label.fontColor = UIColor.whiteColor()
        label.fontSize = 45
        label.position.x = midX
        label.position.y = midY - label.frame.height*3
        label.zPosition = 5
        addChild(label)
        
        let upsideLabel = SKLabelNode(fontNamed:"American Typewriter")
        upsideLabel.position.x = midX
        upsideLabel.zRotation = CGFloat(M_PI)
        upsideLabel.text = text
        upsideLabel.fontColor = UIColor.whiteColor()
        upsideLabel.fontSize = 45
        upsideLabel.position.y = midY + upsideLabel.frame.height*4
        upsideLabel.zPosition = 5
        addChild(upsideLabel)
        
        let fadeIn = SKAction.fadeInWithDuration(1)
        label.runAction(fadeIn){
            label.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(1), SKAction.removeFromParent()]))
        }
        upsideLabel.runAction(fadeIn){
            upsideLabel.runAction(SKAction.sequence([SKAction.fadeOutWithDuration(1), SKAction.removeFromParent()]))
        }
        
        let smoke = SKEmitterNode(fileNamed: "Smoke")!
        smoke.position = label.position
        smoke.zPosition = 6
        
        let upsideSmoke = SKEmitterNode(fileNamed: "Smoke")!
        upsideSmoke.position = upsideLabel.position
        upsideSmoke.zRotation = CGFloat(M_PI)
        upsideSmoke.zPosition = 6
        
        let remove = SKAction.sequence([SKAction.waitForDuration(1), SKAction.fadeOutWithDuration(1), SKAction.removeFromParent()])
        addChild(smoke)
        addChild(upsideSmoke)
        smoke.runAction(remove)
        upsideSmoke.runAction(remove)
    }
    
    func winnerLabel(text:String){
        rearrangeCardsAtDealer()
        
        let label = SKLabelNode(fontNamed:"American Typewriter")
        label.name = "label"
        label.text = text
        label.fontColor = UIColor.whiteColor()
        label.fontSize = 45
        label.position.x = midX
        label.position.y = midY - label.frame.height*3
        label.zPosition = 5
        addChild(label)
        
        let upsideLabel = SKLabelNode(fontNamed:"American Typewriter")
        upsideLabel.name = "upsideLabel"
        upsideLabel.position.x = midX
        upsideLabel.zRotation = CGFloat(M_PI)
        upsideLabel.text = text
        upsideLabel.fontColor = UIColor.whiteColor()
        upsideLabel.fontSize = 45
        upsideLabel.position.y = midY + upsideLabel.frame.height*3.5
        upsideLabel.zPosition = 5
        addChild(upsideLabel)
        
        let fadeIn = SKAction.fadeInWithDuration(1)
        label.runAction(fadeIn)
        upsideLabel.runAction(fadeIn)
        
        let smoke = SKEmitterNode(fileNamed: "Smoke")!
        smoke.name = "smoke"
        smoke.position = label.position
        smoke.zPosition = 6
        addChild(smoke)
        
        let upsideSmoke = SKEmitterNode(fileNamed: "Smoke")!
        upsideSmoke.name = "upsideSmoke"
        upsideSmoke.position = upsideLabel.position
        upsideSmoke.zRotation = CGFloat(M_PI)
        upsideSmoke.zPosition = 6
        addChild(upsideSmoke)
        
        var wait = 1.0
        for _ in 0...10{
            let fireWorks = SKEmitterNode(fileNamed: "FireWorks")!
            fireWorks.position.x = CGFloat(Int.nextRandom(upTo: Int(frame.width)))
            fireWorks.position.y = CGFloat(Int.nextRandom(upTo: Int(frame.height)))
            fireWorks.zPosition = 6
            let remove = SKAction.sequence([SKAction.waitForDuration(wait), SKAction.fadeOutWithDuration(1), SKAction.removeFromParent()])
            addChild(fireWorks)
            fireWorks.runAction(remove)
            wait += 3.0
        }
        
    }
    
    func increaseHandSize(h:(Hand, Player)){
        let hand = h.0
        let player = h.1

        if player.name == "User" && round%2 != 0{
            hand.canThrow = true
            hand.isBig = true
            hand.card1.zPosition = 3
            hand.card2.zPosition = 4
            hand.card1.runAction(SKAction.group([SKAction.scaleBy(1.25, duration: 0.2)]))
            hand.card2.runAction(SKAction.group([SKAction.scaleBy(1.25, duration: 0.2)]))
        }
        else if player.name == "Opponent" && round%2 != 0{
            hand.canThrow = true
            hand.isBig = true
            hand.card1.zPosition = 4
            hand.card2.zPosition = 3
            hand.card1.runAction(SKAction.group([SKAction.scaleBy(1.25, duration: 0.2)]))
            hand.card2.runAction(SKAction.group([SKAction.scaleBy(1.25, duration: 0.2)]))
        }
        else if player.name == "Dealer" && round%2 == 0{
            hand.canThrow = true
            hand.isBig = true
            hand.card1.zPosition = 3
            hand.card2.zPosition = 4
            hand.card1.runAction(SKAction.group([SKAction.scaleBy(1.25, duration: 0.2)]))
            hand.card2.runAction(SKAction.group([SKAction.scaleBy(1.25, duration: 0.2)]))
        }
    }
    
    func decreaseHandSize(h:(Hand, Player)) {
        let hand = h.0
        let player = h.1
      
        if hand.isBig{
            if player.name == "User" && round%2 != 0{
                hand.canThrow = false
                hand.isBig = false
                hand.card1.zPosition = 1
                hand.card2.zPosition = 2
                hand.card1.runAction(SKAction.group([SKAction.scaleBy(0.8, duration: 0.2)]))
                hand.card2.runAction(SKAction.group([SKAction.scaleBy(0.8, duration: 0.2)]))

            }
            else if player.name == "Opponent" && round%2 != 0{
                hand.canThrow = false
                hand.isBig = false
                hand.card1.zPosition = 2
                hand.card2.zPosition = 1
                hand.card1.runAction(SKAction.group([SKAction.scaleBy(0.8, duration: 0.2)]))
                hand.card2.runAction(SKAction.group([SKAction.scaleBy(0.8, duration: 0.2)]))
            }
            else if player.name == "Dealer" && round%2 == 0{
                hand.canThrow = false
                hand.isBig = false
                hand.card1.zPosition = 1
                hand.card2.zPosition = 2
                hand.card1.runAction(SKAction.group([SKAction.scaleBy(0.8, duration: 0.2)]))
                hand.card2.runAction(SKAction.group([SKAction.scaleBy(0.8, duration: 0.2)]))
            }

        }
    }
    
}

extension Int{
    //static function -> called from the class name (Int.nextRandom)
    static func nextRandom(upTo max:Int) -> Int{
        var rand:Int = 0
        arc4random_buf(&rand, sizeof(Int))
        rand = abs(rand)
        rand = rand % max
        return rand
    }
}