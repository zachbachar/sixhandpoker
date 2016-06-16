//
//  Rank.swift
//  SixHandPoker
//
//  Created by zach bachar on 02/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import Foundation

enum Rank:Int, CustomStringConvertible{
    case Two = 2, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King, Ace
    
    var description:String{
        switch self{
        case .Ace:
            return "Ace"
        case .Jack:
            return "Jack"
        case .Queen:
            return "Queen"
        case King:
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