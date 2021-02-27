//
//  WinnerAnimations.swift
//  SixHandPoker
//
//  Created by zach bachar on 25/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import UIKit
import SpriteKit

extension GameScene{
    
    func animateWinnerCards(_ result:(Player, Int, HandRanks, String, [Card])?, kicker:Card?){
        rearrangeCardsAtDealer()
        
        winnerFireworks(amountOfFireWorks: 10)
        
        if let result = result{
            var winningCards = result.4
            if kicker != nil && result.2 != .straight{
                winnerLabel(result.3 + " Kicker " + kicker!.rank.description)
                winningCards.append(kicker!)
            }
            else{
                winnerLabel(result.3)
            }
            let card1 = result.0.hands.first!.card1
            let card2 = result.0.hands.first!.card2
            card1?.zPosition = 6
            card2?.zPosition = 6
            
            switch result.0.name {
            case "User":
                userWon(result: result, card1: card1, card2: card2)
            case "Opponent":
                oppWon(result: result, card1: card1, card2: card2)
            case "Dealer":
                dealerWon(result: result, card1: card1, card2: card2)
            default:
                break
            }
        }
        else{
            tieResult()
        }
    }
    
    func tieResult(){
        let labelPosition = CGPoint(x: self.midX, y: midY)
        let sound = SKAction.playSoundFileNamed("falling", waitForCompletion: false)
        let tieLabel = SKSpriteNode(imageNamed: "tie")
        tieLabel.name = "winnerLabel"
        tieLabel.position = labelPosition
        tieLabel.zPosition = 7
        
        let fallIn = SKAction.group([SKAction.fadeAlpha(to: 1, duration: 0.3), SKAction.scaleX(to: 0.6, duration: 0.3), SKAction.scaleY(to: 0.6, duration: 0.3)])
        let remove = SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()])
        
        let spark = SKEmitterNode(fileNamed: "SmallSpark")!
        spark.zPosition = 6
        spark.position = tieLabel.position
        
        self.addChild(tieLabel)
        tieLabel.run(fallIn, completion: {
            self.run(sound)
            self.addChild(spark)
            spark.run(remove)
        })
    }
    
    func userWon(result:(Player, Int, HandRanks, String, [Card]), card1:Card?, card2:Card?){
        
        let winningCards = result.4
        let enlarge = SKAction.scale(by: 1.8, duration: 0.3)
        let sound = SKAction.playSoundFileNamed("falling", waitForCompletion: false)
        let yPosition = cardsOnTable[0].position.y
        let xPosition1 = cardsOnTable[0].position.x - cardsOnTable[0].frame.width*1.3
        let xPosition2 = cardsOnTable[4].position.x + cardsOnTable[4].frame.width*1.3
        
        let labelPosition = CGPoint(x: self.midX, y: 50)
        card1?.run(SKAction.group([SKAction.move(to: CGPoint(x: midX - (card1?.frame.width)!, y: yPosition) , duration: 0.3)]))
        card2?.run(SKAction.group([SKAction.move(to: CGPoint(x: midX + (card2?.frame.width)! , y:yPosition) , duration: 0.3)]), completion: {
            /*   cards moved to center */
            for card in winningCards{
                if self.cardsOnTable.contains(card){
                    if !card.enlarged{
                        card.run(SKAction.scale(by: 1.2, duration: 0.3))
                        card.enlarged = true
                    }
                }
                else{
                    card.run(enlarge)
                }
            }
            
            card1?.run(SKAction.moveTo(x: xPosition1, duration: 0.3))
            card2?.run(SKAction.moveTo(x: xPosition2, duration: 0.3))
            
            /*   cards moved to sides   */
            
            let winnerLabel = SKSpriteNode(imageNamed: "winner")
            winnerLabel.position = labelPosition
            winnerLabel.zPosition = 7
            winnerLabel.name = "winner"
            
            let winDescription = SKSpriteNode(imageNamed: result.2.description)
            winDescription.zPosition = 7
            winDescription.position = labelPosition
            winDescription.name = "winnerLabel"
            
            let fallIn = SKAction.group([SKAction.fadeAlpha(to: 1, duration: 0.3), SKAction.scaleX(to: 0.6, duration: 0.3), SKAction.scaleY(to: 0.6, duration: 0.3)])
            let remove = SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()])
            let spark = SKEmitterNode(fileNamed: "SmallSpark")!
            spark.zPosition = 6
            spark.position = winnerLabel.position
            
            self.addChild(winDescription)
            winDescription.run(fallIn, completion: {
                self.run(sound)
                winDescription.run(remove)
                self.addChild(spark)
                spark.run(remove, completion: {
                    /*   winner label dissmissed   */
                    self.addChild(winnerLabel)
                    winnerLabel.run(fallIn, completion: {
                        self.run(sound)
                        self.addChild(spark)
                        spark.run(remove)
                    })
                })
            })
            
        })

    }
    
    func oppWon(result:(Player, Int, HandRanks, String, [Card]), card1:Card?, card2:Card?){
        
        let winningCards = result.4
        let enlarge = SKAction.scale(by: 1.8, duration: 0.3)
        let sound = SKAction.playSoundFileNamed("falling", waitForCompletion: false)
        let yPosition = cardsOnTable[0].position.y
        let xPosition1 = cardsOnTable[0].position.x - cardsOnTable[0].frame.width*1.3
        let xPosition2 = cardsOnTable[4].position.x + cardsOnTable[4].frame.width*1.3
        
        let labelPosition = CGPoint(x: self.midX, y: self.frame.height-50)
        card1?.run(SKAction.group([SKAction.move(to: CGPoint(x: midX - (card1?.frame.width)!, y: yPosition) , duration: 0.3)]))
        card2?.run(SKAction.group([SKAction.move(to: CGPoint(x: midX + (card2?.frame.width)! , y:yPosition) , duration: 0.3)]), completion: {
            /*   cards moved to center */
            for card in winningCards{
                if self.cardsOnTable.contains(card){
                    if !card.enlarged{
                        card.run(SKAction.group([SKAction.scale(by: 1.2, duration: 0.3), SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.3)]))
                        card.enlarged = true
                    }
                }
                else{
                    card.run(enlarge)
                }
            }
            
            card1?.run(SKAction.moveTo(x: xPosition1, duration: 0.3))
            card2?.run(SKAction.moveTo(x: xPosition2, duration: 0.3))
            
            /*   cards moved to sides   */
            
            let winnerLabel = SKSpriteNode(imageNamed: "winner")
            winnerLabel.zRotation = CGFloat(Double.pi)
            winnerLabel.position = labelPosition
            winnerLabel.zPosition = 7
            winnerLabel.name = "winner"
            
            let winDescription = SKSpriteNode(imageNamed: result.2.description)
            winDescription.zPosition = 7
            winDescription.zRotation = CGFloat(Double.pi)
            winDescription.position = labelPosition
            winDescription.name = "winnerLabel"
            
            let fallIn = SKAction.group([SKAction.fadeAlpha(to: 1, duration: 0.3), SKAction.scaleX(to: 0.6, duration: 0.3), SKAction.scaleY(to: 0.6, duration: 0.3)])
            let remove = SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()])
            let spark = SKEmitterNode(fileNamed: "SmallSpark")!
            spark.zPosition = 6
            spark.position = winnerLabel.position
            
            self.addChild(winDescription)
                winDescription.run(fallIn, completion: {
                    self.run(sound)
                    winDescription.run(remove)
                    self.addChild(spark)
                    spark.run(remove, completion: {
                        /*   winner label dissmissed   */
                        self.addChild(winnerLabel)
                        winnerLabel.run(fallIn, completion: {
                            //let spark = SKEmitterNode(fileNamed: "SmallSpark")!
                            spark.position = labelPosition
                            //spark.zPosition = 6
                            self.run(sound)
                            self.addChild(spark)
                            spark.run(remove)
                            })
                        })
                    })
            
        })
        
    }
    
    func dealerWon(result:(Player, Int, HandRanks, String, [Card]), card1:Card?, card2:Card?){
        
        let winningCards = result.4
        let enlarge = SKAction.scale(by: 1.8, duration: 0.3)
        let sound = SKAction.playSoundFileNamed("falling", waitForCompletion: false)
        let yPosition = cardsOnTable[0].position.y
        let xPosition1 = cardsOnTable[0].position.x - cardsOnTable[0].frame.width*1.3
        let xPosition2 = cardsOnTable[4].position.x + cardsOnTable[4].frame.width*1.3
        
        // find the right angle!!!
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi/2 + Double.pi), duration: 0.2)
        let labelPosition = CGPoint(x: self.frame.width-50, y: self.midY)
        card1?.run(SKAction.group([SKAction.move(to: CGPoint(x: midX - (card1?.frame.width)!, y: yPosition) , duration: 0.3), rotate]))
        card2?.run(SKAction.group([SKAction.move(to: CGPoint(x: midX + (card2?.frame.width)! , y:yPosition) , duration: 0.3), rotate]), completion: {
            /*   cards moved to center */
            for card in winningCards{
                if self.cardsOnTable.contains(card){
                    if !card.enlarged{
                        card.run(SKAction.scale(by: 1.2, duration: 0.3))
                        card.enlarged = true
                    }
                }
                else{
                    card.run(enlarge)
                }
            }
            card1?.run(SKAction.moveTo(x: xPosition1, duration: 0.3))
            card2?.run(SKAction.moveTo(x: xPosition2, duration: 0.3))
            
            /*   cards moved to sides   */
            
            let winnerLabel = SKSpriteNode(imageNamed: "winner")
            winnerLabel.zRotation = CGFloat(Double.pi/2)
            winnerLabel.position = labelPosition
            winnerLabel.zPosition = 7
            winnerLabel.name = "winner"
            
            let winDescription = SKSpriteNode(imageNamed: result.2.description)
            winDescription.zPosition = 7
            winDescription.zRotation = CGFloat(Double.pi/2)
            winDescription.position = labelPosition
            winDescription.name = "winnerLabel"
            
            let fallIn = SKAction.group([SKAction.fadeAlpha(to: 1, duration: 0.3), SKAction.scaleX(to: 0.6, duration: 0.3), SKAction.scaleY(to: 0.6, duration: 0.3)])
            let remove = SKAction.sequence([SKAction.fadeOut(withDuration: 0.5), SKAction.removeFromParent()])
            let spark = SKEmitterNode(fileNamed: "SmallSpark")!
            spark.zPosition = 6
            spark.zRotation = CGFloat(Double.pi*2)
            spark.position = winnerLabel.position
            
            self.addChild(winDescription)
            winDescription.run(fallIn, completion: {
                self.run(sound)
                winDescription.run(remove)
                self.addChild(spark)
                spark.run(remove, completion: {
                    /*   winner label dissmissed   */
                    self.addChild(winnerLabel)
                    winnerLabel.run(fallIn, completion: {
                        self.run(sound)
                        self.addChild(spark)
                        spark.run(remove)
                    })
                })
            })
        })
        
    }
    
    
    func winnerLabel(_ text:String){
        rearrangeCardsAtDealer()
        
        let label = SKLabelNode(fontNamed:"DayPosterBlackNF")
        label.name = "label"
        label.text = text
        label.fontColor = UIColor.white
        label.fontSize = 40
        label.position.x = midX
        label.position.y = midY - label.frame.height*3.3
        label.zPosition = 5
        addChild(label)
        
        let upsideLabel = SKLabelNode(fontNamed:"DayPosterBlackNF")
        upsideLabel.name = "upsideLabel"
        upsideLabel.position.x = midX
        upsideLabel.zRotation = CGFloat(Double.pi)
        upsideLabel.text = text
        upsideLabel.fontColor = UIColor.white
        upsideLabel.fontSize = 40
        upsideLabel.position.y = midY + upsideLabel.frame.height*4.2
        upsideLabel.zPosition = 5
        addChild(upsideLabel)
        
        let fadeIn = SKAction.fadeIn(withDuration: 1)
        label.run(fadeIn)
        upsideLabel.run(fadeIn)
        
        let smoke = SKEmitterNode(fileNamed: "Smoke")!
        smoke.name = "smoke"
        smoke.position = label.position
        smoke.zPosition = 6
        addChild(smoke)
        
        let upsideSmoke = SKEmitterNode(fileNamed: "Smoke")!
        upsideSmoke.name = "upsideSmoke"
        upsideSmoke.position = upsideLabel.position
        upsideSmoke.zRotation = CGFloat(Double.pi)
        upsideSmoke.zPosition = 6
        addChild(upsideSmoke)
        
    }
    
    func winnerFireworks(amountOfFireWorks count:Int){
        if(count > 0){
            let fireWorks = SKEmitterNode(fileNamed: "FireWorks")!
            fireWorks.position.x = (midX-300) + CGFloat(Int.nextRandom(upTo: Int(midX+200)))
            fireWorks.position.y = (midY-300) + CGFloat(Int.nextRandom(upTo: Int(midY+200)))
            fireWorks.zPosition = 6
            let remove = SKAction.sequence([SKAction.fadeOut(withDuration: 0.8), SKAction.removeFromParent()])
            addChild(fireWorks)
            let x = count-1
            fireWorks.run(remove, completion: {
                self.winnerFireworks(amountOfFireWorks: x)
            })
        }
    }
}

