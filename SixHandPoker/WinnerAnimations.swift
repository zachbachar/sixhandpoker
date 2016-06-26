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
    
    func animateWinnerCards(result:(Player, Int, HandRanks, String, [Card])?){
        rearrangeCardsAtDealer()
        
        let firework = SKEmitterNode(fileNamed: "FireWorks")!
        let fire = SKAction.sequence([
            SKAction.fadeInWithDuration(0.3),
            SKAction.fadeOutWithDuration(0.7),
            SKAction.moveTo(CGPoint(x: CGFloat(Int.nextRandom(upTo: Int(frame.width))), y: CGFloat(Int.nextRandom(upTo: Int(frame.height)))) , duration: 0.1)
            ])
        addChild(firework)
        firework.runAction(SKAction.repeatAction(fire, count: 5))
        
        if let result = result{
            winnerLabel(result.3)
            let card1 = result.0.hands.first!.card1
            let card2 = result.0.hands.first!.card2
            card1.zPosition = 6
            card2.zPosition = 6
            
            let sound = SKAction.playSoundFileNamed("falling", waitForCompletion: false)
            
            let enlarge = SKAction.scaleBy(1.8, duration: 0.3)
            let yPosition = cardsOnTable[0].position.y
            
            switch result.0.name {
            case "User":
                let labelPosition = CGPoint(x: self.midX, y: result.0.hands.first!.card1.position.y)
                card1.runAction(SKAction.group([SKAction.moveTo(CGPoint(x: midX - card1.frame.width, y: yPosition) , duration: 0.3), enlarge]))
                card2.runAction(SKAction.group([SKAction.moveTo(CGPoint(x: midX + card2.frame.width , y:yPosition) , duration: 0.3), enlarge])){
                    /*   cards moved to center */
                    for cardFromTable in self.cardsOnTable{
                        if result.4.contains(cardFromTable) {
                            cardFromTable.runAction(SKAction.scaleBy(1.2, duration: 0.3))
                        }else{
                            cardFromTable.runAction(SKAction.scaleBy(0.9, duration: 0.3))
                        }
                    }
                    
                    card1.runAction(SKAction.moveToX(card1.frame.width, duration: 0.3))
                    card2.runAction(SKAction.moveToX(self.view!.frame.width - card2.frame.width*1.25, duration: 0.3)){
                        /*   cards moved to sides   */
                        
                        let winnerLabel = SKSpriteNode(imageNamed: "winner")
                        winnerLabel.position = labelPosition
                        winnerLabel.zPosition = 7
                        
                        let fallIn = SKAction.group([SKAction.fadeAlphaTo(1, duration: 0.3), SKAction.scaleXTo(0.6, duration: 0.3), SKAction.scaleYTo(0.6, duration: 0.3)])
                        let remove = SKAction.sequence([SKAction.fadeOutWithDuration(0.5), SKAction.removeFromParent()])
                        
                        let spark = SKEmitterNode(fileNamed: "SmallSpark")!
                        spark.zPosition = 6
                        spark.position = winnerLabel.position
                        
                        self.addChild(winnerLabel)
                        winnerLabel.runAction(fallIn){
                            self.runAction(sound)
                            winnerLabel.runAction(remove)
                            self.addChild(spark)
                            spark.runAction(remove){
                                /*   winner label dissmissed   */
                                
                                let winDescription = SKSpriteNode(imageNamed: result.2.description)
                                winDescription.zPosition = 7
                                winDescription.position = labelPosition
                                winDescription.name = "winnerLabel"
                                self.addChild(winDescription)
                                winDescription.runAction(fallIn){
                                    let spark = SKEmitterNode(fileNamed: "SmallSpark")!
                                    spark.position = labelPosition
                                    spark.zPosition = 6
                                    self.runAction(sound)
                                    self.addChild(spark)
                                    spark.runAction(remove)
                                }
                            }
                        }
                        
                    }
                }

            case "Opponent":
                let labelPosition = CGPoint(x: self.midX, y: result.0.hands.first!.card1.position.y)
                card1.runAction(SKAction.group([SKAction.moveTo(CGPoint(x: midX - card1.frame.width, y: yPosition) , duration: 0.3), enlarge]))
                card2.runAction(SKAction.group([SKAction.moveTo(CGPoint(x: midX + card2.frame.width , y:yPosition) , duration: 0.3), enlarge])){
                    /*   cards moved to center */
                    for cardFromTable in result.4{
                        if result.4.contains(cardFromTable) {
                            cardFromTable.runAction(SKAction.scaleBy(1.2, duration: 0.3))
                        }else{
                            cardFromTable.runAction(SKAction.scaleBy(0.9, duration: 0.3))
                        }
                    }
                    
                    card1.runAction(SKAction.moveToX(card1.frame.width, duration: 0.3))
                    card2.runAction(SKAction.moveToX(self.view!.frame.width - card2.frame.width*1.25, duration: 0.3)){
                        /*   cards moved to sides   */
                        
                        let winnerLabel = SKSpriteNode(imageNamed: "winner")
                        winnerLabel.zRotation = CGFloat(M_PI)
                        winnerLabel.position = labelPosition
                        winnerLabel.zPosition = 7
                        
                        let fallIn = SKAction.group([SKAction.fadeAlphaTo(1, duration: 0.3), SKAction.scaleXTo(0.6, duration: 0.3), SKAction.scaleYTo(0.6, duration: 0.3)])
                        let remove = SKAction.sequence([SKAction.fadeOutWithDuration(0.5), SKAction.removeFromParent()])
                        
                        let spark = SKEmitterNode(fileNamed: "SmallSpark")!
                        spark.zPosition = 6
                        spark.position = winnerLabel.position
                        
                        self.addChild(winnerLabel)
                        winnerLabel.runAction(fallIn){
                            self.runAction(sound)
                            winnerLabel.runAction(remove)
                            self.addChild(spark)
                            spark.runAction(remove){
                                /*   winner label dissmissed   */

                                let winDescription = SKSpriteNode(imageNamed: result.2.description)
                                winDescription.zPosition = 7
                                winDescription.zRotation = CGFloat(M_PI)
                                winDescription.position = labelPosition
                                winDescription.name = "winnerLabel"
                                self.addChild(winDescription)
                                winDescription.runAction(fallIn){
                                    let spark = SKEmitterNode(fileNamed: "SmallSpark")!
                                    spark.position = labelPosition
                                    spark.zPosition = 6
                                    self.runAction(sound)
                                    self.addChild(spark)
                                    spark.runAction(remove)
                                }
                            }
                        }
                        
                    }
                }

            case "Dealer":
                
                let rotate = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 0.2)
                let labelPosition = CGPoint(x: self.midX, y: dealerPositions[0].y)
                card1.runAction(SKAction.group([SKAction.moveTo(CGPoint(x: midX - card1.frame.width, y: yPosition) , duration: 0.3), enlarge, rotate]))
                card2.runAction(SKAction.group([SKAction.moveTo(CGPoint(x: midX + card2.frame.width , y:yPosition) , duration: 0.3), enlarge, rotate])){
                    /*   cards moved to center */
                    for cardFromTable in result.4{
                        if result.4.contains(cardFromTable) {
                            cardFromTable.runAction(SKAction.scaleBy(1.2, duration: 0.3))
                        }else{
                            cardFromTable.runAction(SKAction.scaleBy(0.9, duration: 0.3))
                        }
                    }
                    
                    card1.runAction(SKAction.moveToX(card1.frame.width, duration: 0.3))
                    card2.runAction(SKAction.moveToX(self.view!.frame.width - card2.frame.width*1.25, duration: 0.3)){
                        /*   cards moved to sides   */
                        
                        let winnerLabel = SKSpriteNode(imageNamed: "winner")
                        //winnerLabel.zRotation = CGFloat(M_PI_2)
                        winnerLabel.position = labelPosition
                        winnerLabel.zPosition = 7
                        
                        let fallIn = SKAction.group([SKAction.fadeAlphaTo(1, duration: 0.3), SKAction.scaleXTo(0.6, duration: 0.3), SKAction.scaleYTo(0.6, duration: 0.3)])
                        let remove = SKAction.sequence([SKAction.fadeOutWithDuration(0.5), SKAction.removeFromParent()])
                        
                        let spark = SKEmitterNode(fileNamed: "SmallSpark")!
                        spark.zPosition = 6
                        //spark.zRotation = CGFloat(M_PI*2)
                        spark.position = winnerLabel.position
                        
                        self.addChild(winnerLabel)
                        winnerLabel.runAction(fallIn){
                            self.runAction(sound)
                            winnerLabel.runAction(remove)
                            self.addChild(spark)
                            spark.runAction(remove){
                                 /*   winner label dissmissed   */
                                
                                let winDescription = SKSpriteNode(imageNamed: result.2.description)
                                winDescription.zPosition = 7
                                //winDescription.zRotation = CGFloat(M_PI_2)
                                winDescription.position = labelPosition
                                winDescription.name = "winnerLabel"
                                self.addChild(winDescription)
                                winDescription.runAction(fallIn){
                                    let spark = SKEmitterNode(fileNamed: "SmallSpark")!
                                    spark.position = labelPosition
                                    spark.zPosition = 6
                                    self.runAction(sound)
                                    self.addChild(spark)
                                    spark.runAction(remove)
                                }
                            }
                        }
                    }
                }
            default:
                break
            }
        }
        else{
            /*                TIE   			   */
            let labelPosition = CGPoint(x: self.midX, y: midY)
            let sound = SKAction.playSoundFileNamed("falling", waitForCompletion: false)
            let winnerLabel = SKSpriteNode(imageNamed: "winner")
            winnerLabel.position = labelPosition
            winnerLabel.zPosition = 7
            
            let fallIn = SKAction.group([SKAction.fadeAlphaTo(1, duration: 0.3), SKAction.scaleXTo(0.6, duration: 0.3), SKAction.scaleYTo(0.6, duration: 0.3)])
            let remove = SKAction.sequence([SKAction.fadeOutWithDuration(0.5), SKAction.removeFromParent()])
            
            let spark = SKEmitterNode(fileNamed: "SmallSpark")!
            spark.zPosition = 6
            spark.position = winnerLabel.position
            
            self.addChild(winnerLabel)
            winnerLabel.runAction(fallIn){
                self.runAction(sound)
                self.addChild(spark)
                spark.runAction(remove)
            }
        }
    }
    
    func winnerLabel(text:String){
        rearrangeCardsAtDealer()
        
        let label = SKLabelNode(fontNamed:"DayPosterBlackNF")
        label.name = "label"
        label.text = text
        label.fontColor = UIColor.whiteColor()
        label.fontSize = 40
        label.position.x = midX
        label.position.y = midY - label.frame.height*3.3
        label.zPosition = 5
        addChild(label)
        
        let upsideLabel = SKLabelNode(fontNamed:"DayPosterBlackNF")
        upsideLabel.name = "upsideLabel"
        upsideLabel.position.x = midX
        upsideLabel.zRotation = CGFloat(M_PI)
        upsideLabel.text = text
        upsideLabel.fontColor = UIColor.whiteColor()
        upsideLabel.fontSize = 40
        upsideLabel.position.y = midY + upsideLabel.frame.height*4.2
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
        
        /*var wait = 1.0
         for _ in 0...10{
         let fireWorks = SKEmitterNode(fileNamed: "FireWorks")!
         fireWorks.position.x = CGFloat(Int.nextRandom(upTo: Int(frame.width)))
         fireWorks.position.y = CGFloat(Int.nextRandom(upTo: Int(frame.height)))
         fireWorks.zPosition = 6
         let remove = SKAction.sequence([SKAction.waitForDuration(wait), SKAction.fadeOutWithDuration(1), SKAction.removeFromParent()])
         addChild(fireWorks)
         fireWorks.runAction(remove)
         wait += 3.0
         }*/
    }

}

