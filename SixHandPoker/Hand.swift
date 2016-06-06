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
        return "\(card1) \(card2)"
    }
}

//-------------Operators------------
func == (lhs:Hand, rhs:Hand) -> Bool{
    return ((lhs.card1 == rhs.card1 && lhs.card2 == rhs.card2) ||
        lhs.card1 == rhs.card2 && lhs.card2 == rhs.card1)
}

