//
//  HandRanks.swift
//  SixHandPoker
//
//  Created by zach bachar on 07/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import UIKit

extension Hand{
    
    enum HandRanks:Int{
        case HighCard = 0
        case Pair
        case TwoPairs
        case ThreeOfKind
        case Straight
        case Flush
        case FullHouse
        case FourOfKind
        case StraightFlush
        case RoyalFlush
    }
    
    func checkHandRank(cards:[Card]) -> HandRanks{
        finalCards = cards
        
        if isRoyalFlush(){
            return .RoyalFlush
        }
        else if isStraightFlush(){
            return.StraightFlush
        }
        else if isFourOfKind(){
            return .FourOfKind
        }
        else if isFullHouse(){
            return .FullHouse
        }
        else if isFlush(){
            return .Flush
        }
        else if isStraight(){
            return .Straight
        }
        else if isThreeOfKind(){
            return .ThreeOfKind
        }
        else if isTwoPairs(){
            return .TwoPairs
        }else if isPair(){
            return .Pair
        }
        else{
            return .HighCard
        }
    }
    
    func isHighCard() -> Bool{
        
        return true
    }
    
    func isPair() -> Bool{
        
        return true
    }
    
    func isTwoPairs() -> Bool{
        
        return true
    }
    
    func isThreeOfKind() -> Bool{
        
        return true
    }
    
    func isStraight() -> Bool{
        
        return true
    }
    
    func isFlush() -> Bool{
        
        return true
    }
    
    func isFullHouse() -> Bool{
        
        return true
    }
    
    func isFourOfKind() -> Bool{
        
        return true
    }
    
    func isStraightFlush() -> Bool{
        
        return true
    }
    
    func isRoyalFlush() -> Bool{
        
        return true
    }
}
