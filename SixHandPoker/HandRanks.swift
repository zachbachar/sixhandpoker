//
//  HandRanks.swift
//  SixHandPoker
//
//  Created by zach bachar on 07/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import UIKit

enum HandRanks:Int, CustomStringConvertible{
    case highCard = 1
    case pair = 8
    case twoPairs = 37
    case threeOfKind = 266
    case straight = 745
    case flush = 1491
    case fullHouse = 10437
    case fourOfKind = 73066
    case straightFlush = 204585
    case royalFlush = 204586
    
    var description: String{
        switch self {
        case .highCard:
            return "High Card"
        case .pair:
            return "Pair"
        case .twoPairs:
            return "Two Pairs"
        case .threeOfKind:
            return "Three Of A Kind"
        case .straight:
            return "Straight"
        case .flush:
            return "Flush"
        case .fullHouse:
            return "Full House"
        case .fourOfKind:
            return "Four Of A Kind"
        case .straightFlush:
            return "Straight Flush"
        case .royalFlush:
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
