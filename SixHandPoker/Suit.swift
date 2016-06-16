//
//  Suit.swift
//  SixHandPoker
//
//  Created by zach bachar on 02/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import Foundation

enum Suit:Int, CustomStringConvertible{
    
    case Spades = 1, Hearts, Diamonds, Clubs
    
    var description:String{
        switch self{
        case .Spades:
            return "Spades"
        case .Hearts:
            return "Hearts"
        case .Diamonds:
            return "Diamonds"
        case .Clubs:
            return "Clubs"
        }
    }
    
    var shortName:String{
        switch self {
        case .Spades:
            return "s"
        case .Hearts:
            return "h"
        case .Diamonds:
            return "d"
        case.Clubs:
            return "c"
        }
    }
}

/*--------------------Operators-------------------------*/

func == (lhs:Suit, rhs:Suit) -> Bool{
    return lhs.rawValue == rhs.rawValue
}