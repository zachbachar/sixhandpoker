//
//  HandRanks.swift
//  SixHandPoker
//
//  Created by zach bachar on 07/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import UIKit

enum HandRanks:Int, CustomStringConvertible{
    case HighCard = 1
    case Pair = 8
    case TwoPairs = 37
    case ThreeOfKind = 266
    case Straight = 745
    case Flush = 1491
    case FullHouse = 10437
    case FourOfKind = 73066
    case StraightFlush = 204585
    case RoyalFlush = 204586
    
    var description: String{
        switch self {
        case .HighCard:
            return "High Card"
        case .Pair:
            return "Pair"
        case .TwoPairs:
            return "Two Pairs"
        case .ThreeOfKind:
            return "Three Of A Kind"
        case .Straight:
            return "Straight"
        case .Flush:
            return "Flush"
        case .FullHouse:
            return "Full House"
        case .FourOfKind:
            return "Four Of A Kind"
        case .StraightFlush:
            return "Straight Flush"
        case .RoyalFlush:
            return "Royal Flush"
        }
    }
}


/*--------------------------Operators--------------------------*/

func > (lhs:HandRanks, rhs:HandRanks) -> Bool{
    return lhs.rawValue > rhs.rawValue
}

func == (lhs:HandRanks, rhs:HandRanks) -> Bool{
    return lhs.rawValue == rhs.rawValue
}