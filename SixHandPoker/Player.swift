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
    var name:String
    
    init(name:String){
        hands = [Hand]()
        self.name = name
    }
    
    func handValue(tableCards:[Card]) -> (Player, Int, HandRanks){
        var finalCards = tableCards
        finalCards.append(hands.first!.card1)
        finalCards.append(hands.first!.card2)
        finalCards.sortInPlace { (c1, c2) -> Bool in
            return c1.rank.rawValue < c2.rank.rawValue
        }
        
        let ans = hands.first!.handScore(finalCards)
        let score = ans.0
        let rank = ans.1
        //let message = ans.1
        
        return (self, score, rank)
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