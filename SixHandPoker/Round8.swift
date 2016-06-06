//
//  Round8.swift
//  SixHandPoker
//
//  Created by zach bachar on 05/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import UIKit

extension GameScene{
    
    func roundEIGHT(card1:Card){
        if dealer.hands.count > 1{
            for hand in dealer.hands{
                if card1 == hand.card1{
                    dissmissHand(hand)
                }
                else if card1 == hand.card2{
                    dissmissHand(hand)
                }
            }
        }
    }
}
