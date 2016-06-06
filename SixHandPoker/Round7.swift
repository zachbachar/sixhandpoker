//
//  Round7.swift
//  SixHandPoker
//
//  Created by zach bachar on 05/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import UIKit

extension GameScene{
    
    func roundSEVEN(card1:Card){
        if user.hands.count > 1{
            for hand in user.hands{
                if card1 == hand.card1{
                    moveToDealer(hand, player: user)
                }
                else if card1 == hand.card2{
                    moveToDealer(hand, player: user)
                }
            }
        }
        if opponent.hands.count > 1{
            for hand in opponent.hands{
                if card1 == hand.card1{
                    moveToDealer(hand, player: opponent)
                }
                else if card1 == hand.card2{
                    moveToDealer(hand, player: opponent)
                }
            }
        }
    }
}
