//
//  Suit.swift
//  SixHandPoker
//
//  Created by zach bachar on 02/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import Foundation

enum Suit:Int, CustomStringConvertible{
    
    case spades = 1, hearts, diamonds, clubs
    
    var description:String{
        switch self{
        case .spades:
            return "Spades"
        case .hearts:
            return "Hearts"
        case .diamonds:
            return "Diamonds"
        case .clubs:
            return "Clubs"
        }
    }
    
    var shortName:String{
        switch self {
        case .spades:
            return "s"
        case .hearts:
            return "h"
        case .diamonds:
            return "d"
        case.clubs:
            return "c"
        }
    }
}

/*--------------------Operators-------------------------*/

func == (lhs:Suit, rhs:Suit) -> Bool{
    return lhs.rawValue == rhs.rawValue
}
