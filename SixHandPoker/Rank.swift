//
//  Rank.swift
//  SixHandPoker
//
//  Created by zach bachar on 02/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import Foundation

enum Rank:Int, CustomStringConvertible{
    case lowAce = 1
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king, ace
    
    var description:String{
        switch self{
        case .ace:
            return "Ace"
        case .jack:
            return "Jack"
        case .queen:
            return "Queen"
        case .king:
            return "King"
        default:
            return "\(self.rawValue)"
        }
    }
    
    var value:Int{
        return self.rawValue
    }
}

/*---------------Operators------------------*/

func < (lhs:Rank, rhs:Rank) -> Bool{
    return lhs.rawValue < rhs.rawValue
}

func > (lhs:Rank, rhs:Rank) -> Bool{
    return lhs.rawValue > rhs.rawValue
}

func != (lhs:Rank, rhs:Rank) -> Bool{
    return lhs.rawValue != rhs.rawValue
}

func == (lhs:Rank, rhs:Rank) -> Bool{
    return lhs.rawValue == rhs.rawValue
}

func == (lhs:Rank, rhs:Int) -> Bool{
    return lhs.rawValue == rhs
}

func + (lhs:Rank, rhs:Int) -> Int{
    return lhs.rawValue + rhs
}

func - (lhs:Rank, rhs:Int) -> Int{
    return lhs.rawValue - rhs
}
