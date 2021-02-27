//
//  Hand.swift
//  SixHandPoker
//
//  Created by zach bachar on 02/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import Foundation

class Hand: CustomStringConvertible{
    var card1:Card!
    var card2:Card!
    var finalCards:[Card]!
    var canThrow:Bool = false
    var isBig:Bool = false
    
    init(card1 c1:Card, card2 c2:Card){
        card1 = c1
        card2 = c2
    }

    init(card1 c1:Card){
        card1 = c1
        card2 = nil
    }
    
    init(){
        card1 = nil
        card2 = nil
    }
    
    var description:String{
        return "\(String(describing: card1)) \(String(describing: card2))"
    }
}

extension GameScene{
    func findHand(_ card1:Card) -> (Hand, Player)?{
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

//-------------Operators------------
func == (lhs:Hand, rhs:Hand) -> Bool{
    return ((lhs.card1 == rhs.card1 && lhs.card2 == rhs.card2) ||
        lhs.card1 == rhs.card2 && lhs.card2 == rhs.card1)
}
