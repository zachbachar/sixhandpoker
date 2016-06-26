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
        
        print("User: \(results[0].3) - score: \(results[0].1)")
        print("Opp: \(results[1].3) - score: \(results[1].1)")
        print("Dealer: \(results[2].3) - score: \(results[2].1)")
        
        let temp = results.sort { (x, y) -> Bool in
            return x.1 > y.1
        }
        
        results = temp
        
        //Tie Handeling
        if results[0].1 == results[1].1{
            if results[0].2 == .Straight || results[0].2 == .StraightFlush{
                //winnerLabel("Its A Tie With" + results.first!.3)
                animateWinnerCards(results[0])
            }
            else {
                var p1Cards = results[0].0.hands.first!.finalCards
                var p2Cards = results[1].0.hands.first!.finalCards
                
                p1Cards.sortInPlace({ (c1, c2) -> Bool in
                    return c1.rank.rawValue > c2.rank.rawValue
                })
                p2Cards.sortInPlace({ (c1, c2) -> Bool in
                    return c1.rank.rawValue > c2.rank.rawValue
                })
                
                repeat{
                    if p1Cards.first!.rank > p2Cards.first!.rank{
                        //winnerLabel("Kicker \(p1Cards.first!.rank)")
                        animateWinnerCards(results[0])
                        return
                    }
                    if p1Cards.first!.rank < p2Cards.first!.rank{
                        //winnerLabel("Kicker \(p2Cards.first!.rank)")
                        animateWinnerCards(results[1])
                        return
                    }
                    p1Cards.removeFirst()
                    p2Cards.removeFirst()
                } while (p1Cards.count > 2)
                
                //winnerLabel("Its A Tie With" + results.first!.3)
                animateWinnerCards(nil)
                return
            }
        }
        
        //winnerLabel("\(results.first!.0.name) Wins With " + results.first!.3)
        animateWinnerCards(results[0])
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
        
        if let touching = touched{
            if let hand = findHand(touching){
                decreaseHandSize(hand)
                touched = nil
            }
        }
        
    }

    var touched:Card?
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
                        if touched == nil{
                            touched = card1
                            increaseHandSize(hand)
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!
        let location = touch.locationInNode(self)
        //let touchedNode = nodeAtPoint(location)
        
        guard let touching = touched else {return}
        if !touching.frame.contains(location){
            if let hand = findHand(touching){
                decreaseHandSize(hand)
            }
            touched = nil
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
