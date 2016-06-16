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
    
    func handValue(tableCards:[Card]) -> (HandRanks, Card, String){
        var finalCards = tableCards
        finalCards.append(hands.first!.card1)
        finalCards.append(hands.first!.card2)
        finalCards.sortInPlace { (c1, c2) -> Bool in
            return c1.rank.rawValue < c2.rank.rawValue
        }
        return hands.first!.checkHandRank(finalCards)
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