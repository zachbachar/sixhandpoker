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
    
    var round = 0
    
    var cardsOnTable = [Card]()
    var dealerPositions = [CGPointMake(900, 150), CGPointMake(900, 250), CGPointMake(900, 350), CGPointMake(900, 450), CGPointMake(900, 550), CGPointMake(900, 650)]
    
    var canPlay = false
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here*/
        initGame()
        initFirstDraw()
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
    
    
        
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if round == 1{
            if user.hands.count == 4 && opponent.hands.count == 4{
                round += 1
                print("round two")
            }
        }
        else if round == 2{
            if dealer.hands.count == 2{
                canPlay = false
                rearrangeCardsAtDealer()
                round += 1
                
                cardsOnTable[1].flip(1, complition: {
                    self.canPlay = true
                    print("round three")
                })
            }
        }
        else if round == 3{
            if user.hands.count == 3 && opponent.hands.count == 3{
                round += 1
                print("round four")
            }
        }
        else if round == 4{
            if dealer.hands.count == 3{
                canPlay = false
                rearrangeCardsAtDealer()
                round += 1
                
                cardsOnTable[2].flip(1, complition: {
                    self.canPlay = true
                    print("round five")
                })
            }
        }
        else if round == 5{
            if user.hands.count == 2 && opponent.hands.count == 2{
                round += 1
                print("round six")
            }
        }
        else if round == 6{
            if dealer.hands.count == 4{
                canPlay = false
                rearrangeCardsAtDealer()
                round += 1
                
                cardsOnTable[3].flip(1, complition: {
                    self.canPlay = true
                    print("round seven")
                })
            }
        }
        else if round == 7{
            if user.hands.count == 1 && opponent.hands.count == 1{
                round += 1
                print("round eight")
            }
        }
        else if round == 8{
            if dealer.hands.count == 1{
                canPlay = false
                round += 1
                
                cardsOnTable[4].flip(1, complition: {
                    self.canPlay = true
                    print("END")
                })
            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Called when a touch begins
        for touch in touches {
            let location = touch.locationInNode(self)
            let touchedNode = nodeAtPoint(location)
            
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
