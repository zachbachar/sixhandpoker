//
//  Rank.swift
//  SixHandPoker
//
//  Created by zach bachar on 02/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import Foundation

enum Rank:Int, CustomStringConvertible{
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    
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
        switch self{
        case .King:
            return 13
        case .Queen:
            return 12
        case .Jack:
            return 11
        default:
            return self.rawValue
        }
    }
}