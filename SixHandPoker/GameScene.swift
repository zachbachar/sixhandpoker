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
    var user = Player()
    var opponent = Player()
    var dealer = Player()
    
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
        let userScore = user.handValue(self.cardsOnTable)
        let oppScore = opponent.handValue(self.cardsOnTable)
        let dealerScore = dealer.handValue(self.cardsOnTable)
        
        if userScore.0 > oppScore.0 && userScore.0 > dealerScore.0{
            winnerLabel("User Wins With a \(userScore.2)")
        }
        else if oppScore.0 > userScore.0 && oppScore.0 > dealerScore.0{
            winnerLabel("Opponent Winns With a \(oppScore.2)")
        }
        else if dealerScore.0 > userScore.0 && dealerScore.0 > oppScore.0{
            winnerLabel("Dealer Winns With a \(dealerScore.2)")
        }
        else if userScore.0 == oppScore.0 || userScore.0 == dealerScore.0 || oppScore.0 == dealerScore.0{
            winnerLabel("It's A Tie!")
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
            if round == 1{
                if user.hands.count == 4 && opponent.hands.count == 4{
                    round += 1
                    self.roundLabel("Dealers Turn!")
                }
            }
            else if round == 2{
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
                if user.hands.count == 3 && opponent.hands.count == 3{
                    round += 1
                    self.roundLabel("Dealers Turn!")
                }
            }
            else if round == 4{
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
                if user.hands.count == 2 && opponent.hands.count == 2{
                    round += 1
                    self.roundLabel("Dealers Turn!")
                }
            }
            else if round == 6{
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
                if user.hands.count == 1 && opponent.hands.count == 1{
                    round += 1
                    self.roundLabel("Dealers Turn!")
                }
            }
            else if round == 8{
                if dealer.hands.count == 1{
                    canPlay = false
                    round += 1
                    
                    cardsOnTable[4].flip(1, complition: {
                        self.endGame()
                    })
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
                if round == 1 && canPlay {
                    roundONE(card1)
                }else if round == 2 && canPlay{
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
            }
        }
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
