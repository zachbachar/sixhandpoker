//
//  GameSceneTouches.swift
//  SixHandPoker
//
//  Created by Zach Bachar on 29/11/2017.
//  Copyright © 2017 zach bachar. All rights reserved.
//

import SpriteKit

extension GameScene{
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if let card1 = touchedNode as? Card{
            if let hand = findHand(card1){
                if round == 1{
                    if canPlay && hand.0.canThrow{
                        decreaseHandSize(hand)
                        roundONE(card1: card1)
                    }
                    if user.hands.count == 4 && opponent.hands.count == 4{
                        round += 1
                        self.roundLabel("Dealers Turn!")
                    }
                }
                else if round == 2{
                    if canPlay && hand.0.canThrow{
                        decreaseHandSize(hand)
                        roundTWO(card1: card1)
                    }
                    if dealer.hands.count == 2{
                        canPlay = false
                        rearrangeCardsAtDealer()
                        round += 1
                        
                        cardsOnTable[1].flip(1, complition: {
                            self.canPlay = true
                            print("round two")
                            self.roundLabel("Round Two")
                        })
                    }
                }
                else if round == 3{
                    if canPlay && hand.0.canThrow{
                        decreaseHandSize(hand)
                        roundTHREE(card1: card1)
                    }
                    if user.hands.count == 3 && opponent.hands.count == 3{
                        round += 1
                        self.roundLabel("Dealers Turn!")
                    }
                }
                else if round == 4{
                    if canPlay && hand.0.canThrow{
                        decreaseHandSize(hand)
                        roundFOUR(card1: card1)
                    }
                    if dealer.hands.count == 3{
                        canPlay = false
                        rearrangeCardsAtDealer()
                        round += 1
                        
                        cardsOnTable[2].flip(1, complition: {
                            self.canPlay = true
                            self.roundLabel("Round Three")
                        })
                    }
                }
                else if round == 5{
                    if canPlay && hand.0.canThrow{
                        decreaseHandSize(hand)
                        roundFIVE(card1: card1)
                    }
                    if user.hands.count == 2 && opponent.hands.count == 2{
                        round += 1
                        self.roundLabel("Dealers Turn!")
                    }
                }
                else if round == 6{
                    if canPlay && hand.0.canThrow{
                        decreaseHandSize(hand)
                        roundSIX(card1: card1)
                    }
                    if dealer.hands.count == 4{
                        canPlay = false
                        rearrangeCardsAtDealer()
                        round += 1
                        
                        cardsOnTable[3].flip(1, complition: {
                            self.canPlay = true
                            self.roundLabel("Round Four")
                        })
                    }
                }
                else if round == 7{
                    if canPlay && hand.0.canThrow{
                        decreaseHandSize(hand)
                        roundSEVEN(card1: card1)
                    }
                    if user.hands.count == 1 && opponent.hands.count == 1{
                        round += 1
                        self.roundLabel("Dealers Turn!")
                    }
                }
                else if round == 8{
                    if canPlay && hand.0.canThrow{
                        decreaseHandSize(hand)
                        roundEIGHT(card1: card1)
                    }
                    if dealer.hands.count == 1{
                        canPlay = false
                        round += 1
                        
                        cardsOnTable[4].flip(1, complition: {
                            self.endGame()
                        })
                    }
                }
            }
        }
        
        if let touching = touched{
            if let hand = findHand(touching){
                decreaseHandSize(hand)
            }
        }
        touched = nil
    }
    
    var touched:Card?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Called when a touch begins
        let touch = touches.first!
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        if touchedNode.name == "newGameBtn"{
            clearTable()
        }
        else{
            if let card1 = touchedNode as? Card{
                if canPlay{
                    if let hand = findHand(card1){
                        if touched == nil{
                            touched = card1
                            increaseHandSize(hand)
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        //let touchedNode = nodeAtPoint(location)
        
        if let touching = touched{
            if !touching.frame.contains(location){
                if let hand = findHand(touching){
                    decreaseHandSize(hand)
                }
                touched = nil
            }
        }
    }
}
