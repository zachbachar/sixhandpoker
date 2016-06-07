//
//  Player.swift
//  SixHandPoker
//
//  Created by zach bachar on 02/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import UIKit

class Player{

    var hands:[Hand]
    
    init(){
        hands = [Hand]()
    }
    
    func removeHand(hand hand:Hand) -> Hand{
        var indexToRemove = 0
        for index in 0...hands.count - 1 {
            if hands[index] == hand{
                indexToRemove = index
            }
        }
        return hands.removeAtIndex(indexToRemove)
    }
}