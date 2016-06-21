//
//  GameScene.swift
//  SixHandPoker
//
//  Created by zach bachar on 02/06/2016.
//  Copyright (c) 2016 zach bachar. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var deck = Deck()
    var user = Player(name: "User")
    var opponent = Player(name: "Opponent")
    var dealer = Player(name: "Dealer")
    
    var midX = CGFloat()
    var midY = CGFloat()
    
    var round = 0
    
    var cardsOnTable = [Card]()
    var dealerPositions = [CGPointMake(900, 150), CGPointMake(900, 250), CGPointMake(900, 350), CGPointMake(900, 450), CGPointMake(900, 550), CGPointMake(900, 650)]
    
    var canPlay = false
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here*/
        midX = CGRectGetMidX(self.frame)
        midY = CGRectGetMidY(self.frame)
        initGame()
        initFirstDraw()
    }
    
    func resetGame() -> SKAction{
        deck = Deck()
        user.hands.removeAll()
        dealer.hands.removeAll()
        opponent.hands.removeAll()
        cardsOnTable.removeAll()
        initGame()
        initFirstDraw()
        return SKAction()
    }
    
    func initGame(){
        deck.shuffle()
        
        for _ in 0..<6{
            user.hands.append(Hand(card1: deck.drawCard()))
            opponent.hands.append(Hand(card1: deck.drawCard()))
        }
        for i in 0..<6{
            user.hands[i].card2 = deck.drawCard()
            opponent.hands[i].card2 = deck.drawCard()
        }
        for _ in 0..<5{
            cardsOnTable.append(deck.drawCard())
        }
    }
    
    func endGame(){
        canPlay = false
        round = 0
        checkForWinner()
        addNewGameButton()
    }
    
    func checkForWinner(){
        var results = [user.handValue(self.cardsOnTable),
                       opponent.handValue(self.cardsOnTable),
                       dealer.handValue(self.cardsOnTable)]
        
        let temp = results.sort { (x, y) -> Bool in
            return x.1 > y.1
        }
        
        results = temp
        
        winnerLabel("\(results.first!.0.name) Wins With " + results.first!.3)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let location = touch.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        
        if let card1 = touchedNode as? Card{
            if let hand = findHand(card1){
                if round == 1{
                    if canPlay && hand.0.canThrow{
                        decreaseHandSize(hand)
                        roundONE(card1)
                    }
                    if user.hands.count == 4 && opponent.hands.count == 4{
                        round += 1
                        self.roundLabel("Dealers Turn!")
                    }
                }
                else if round == 2{
                    if canPlay && hand.0.canThrow{
                        decreaseHandSize(hand)
                        roundTWO(card1)
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
                        roundTHREE(card1)
                    }
                    if user.hands.count == 3 && opponent.hands.count == 3{
                        round += 1
                        self.roundLabel("Dealers Turn!")
                    }
                }
                else if round == 4{
                    if canPlay && hand.0.canThrow{
                        decreaseHandSize(hand)
                        roundFOUR(card1)
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
                        roundFIVE(card1)
                    }
                    if user.hands.count == 2 && opponent.hands.count == 2{
                        round += 1
                        self.roundLabel("Dealers Turn!")
                    }
                }
                else if round == 6{
                    if canPlay && hand.0.canThrow{
                        decreaseHandSize(hand)
                        roundSIX(card1)
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
                        roundSEVEN(card1)
                    }
                    if user.hands.count == 1 && opponent.hands.count == 1{
                        round += 1
                        self.roundLabel("Dealers Turn!")
                    }
                }
                else if round == 8{
                    if canPlay && hand.0.canThrow{
                        decreaseHandSize(hand)
                        roundEIGHT(card1)
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
        
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Called when a touch begins
        let touch = touches.first!
        let location = touch.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        if touchedNode.name == "newGameBtn"{
            clearTable()
        }
        else{
            if let card1 = touchedNode as? Card{
                if canPlay{
                    if let hand = findHand(card1){
                        increaseHandSize(hand)
                    }
                }
            
                /* if round == 1 && canPlay {
                    roundONE(card1)
                }
            else if round == 2 && canPlay{
                    roundTWO(card1)
                }
                else if round == 3 && canPlay{
                    roundTHREE(card1)
                }
                else if round == 4 && canPlay{
                    roundFOUR(card1)
                }
                else if round == 5 && canPlay{
                    roundFIVE(card1)
                }
                else if round == 6 && canPlay{
                    roundSIX(card1)
                }
                else if round == 7 && canPlay{
                    roundSEVEN(card1)
                }
                else if round == 8 && canPlay{
                    roundEIGHT(card1)
                }
            }*/
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let location = touch.locationInNode(self)
        let touchedNode = nodeAtPoint(location)
        
        if canPlay{
            if let card1 = touchedNode as? Card{
                if let hand = findHand(card1){
                    decreaseHandSize(hand)
                }
            }
        }
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func findHand(card1:Card) -> (Hand, Player)?{
        for hand in user.hands{
            if card1 == hand.card1{
                return (hand, user)
            }
            else if card1 == hand.card2{
                return (hand, user)
            }
        }
        
        for hand in opponent.hands{
            if card1 == hand.card1{
                return (hand, opponent)
            }
            else if card1 == hand.card2{
                return (hand, opponent)
            }
        }
        
        for hand in dealer.hands{
            if card1 == hand.card1{
                return (hand, dealer)
            }
            else if card1 == hand.card2{
                return (hand, dealer)
            }
        }
        return nil
    }
}
