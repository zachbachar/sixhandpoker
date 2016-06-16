//
//  HandRanks.swift
//  SixHandPoker
//
//  Created by zach bachar on 07/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import UIKit

extension Hand{
    
    enum HandRanks:Int, CustomStringConvertible{
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
    
    func checkHandRank(cards:[Card]) -> HandRanks{
        finalCards = cards
        finalCards.sortInPlace { (c1, c2) -> Bool in
            return c1.rank.rawValue < c2.rank.rawValue
        }
        
        if isRoyalFlush(){
            return .RoyalFlush
        }
        else if isStraightFlush().0{
            return.StraightFlush
        }
        else if isFourOfKind().0{
            return .FourOfKind
        }
        else if isFullHouse().0{
            return .FullHouse
        }
        else if isFlush().0{
            return .Flush
        }
        else if isStraight().0{
            return .Straight
        }
        else if isThreeOfKind().0{
            return .ThreeOfKind
        }
        else if isTwoPairs().0{
            return .TwoPairs
        }else if isPair().0{
            return .Pair
        }
        else{
            return .HighCard
        }
    }
    
    func isHighCard() -> (Bool, Card?){
        return (true, finalCards.last)
    }
    
    func isPair() -> (Bool, Card?){
        let maxStartPosition = finalCards.count - 1
        for i in 0..<maxStartPosition{
            if finalCards[i].rank == finalCards[i+1].rank{
                return (true, finalCards[i])
            }
        }
        return (false, nil)
    }
    
    func isTwoPairs() -> (Bool, Card?){
        var pairsCount = 0
        let maxStartPosition = finalCards.count - 1
        for i in 0..<maxStartPosition{
            if finalCards[i].rank == finalCards[i+1].rank{
                pairsCount += 1
                if pairsCount == 2{
                    return (true, finalCards[i])
                }
            }
        }
        return (false, nil)
    }
    
    func isThreeOfKind() -> (Bool, Card?){
        let maxStartPosition = finalCards.count - 2
        for i in 0..<maxStartPosition{
            if finalCards[i].rank == finalCards[i+1].rank && finalCards[i].rank == finalCards[i+2].rank{
                return(true, finalCards[i])
            }
        }
        return (false, nil)
    }
    
    func isStraight() -> (Bool, Card?){
        var cards = finalCards
        var indexToRemove = [Int]()
        for i in 0..<cards.count-1{
            if cards[i].rank == cards[i+1].rank{
                indexToRemove.append(i+1)
            }
        }
       
        if indexToRemove.count > 0{
            var newCards = [Card]()
            for i in 0...cards.count-1{
                if !indexToRemove.contains(i){
                    newCards.append(cards[i])
                }
            }
            cards = newCards
        }
        
        if cards.count < 5{
            return (false,nil)
        }
        
        let maxStartPosition = finalCards.count - 4
        for i in 0..<maxStartPosition{
            let compare1 = finalCards[i] << finalCards[i+1]
            let compare2 = finalCards[i+1] << finalCards[i+2]
            let compare3 = finalCards[i+2] << finalCards[i+3]
            let compare4 = finalCards[i+3] << finalCards[i+4]
            
            if compare1 && compare2 && compare3 && compare4{
                return (true, finalCards[i+4])
            }
        }
        return (false, nil)
    }
    
    func isFlush() -> (Bool, Card?){
        var spadesCount = 0
        var heartCount = 0
        var diamondCount = 0
        var clubsCount = 0
        var highCard:Card?
        
        for card in finalCards{
            switch card.suit.shortName {
            case "c":
              clubsCount += 1
              if clubsCount >= 5{
                highCard = card
                }
            case "d":
                diamondCount += 1
                if diamondCount >= 5{
                    highCard = card
                }
            case "h":
                heartCount += 1
                if heartCount >= 5{
                    highCard = card
                }
            case "s":
                spadesCount += 1
                if spadesCount >= 5{
                    highCard = card
                }
            default:
                break
            }
        }
        
        if let highCard = highCard{
            return (true, highCard)
        }
        else{
            return (false, nil)
        }
    }
    
    func isFullHouse() -> (Bool, Card?){
        if let pairCard = isPair().1{
            if let threeCard = isThreeOfKind().1{
                if pairCard.rank != threeCard.rank{
                    return (true, threeCard)
                }
            }
        }
        return (false, nil)
    }
    
    func isFourOfKind() -> (Bool, Card?){
        let maxStartPosiotin = finalCards.count - 3
        for i in 0..<maxStartPosiotin{
            let compare1 = finalCards[i].rank == finalCards[i+1].rank
            let compare2 = finalCards[i].rank == finalCards[i+2].rank
            let compare3 = finalCards[i].rank == finalCards[i+3].rank
            
            if compare1 && compare2 && compare3{
                return(true, finalCards[i])
            }
        }
        return (false, nil)
    }
    
    func isStraightFlush() -> (Bool, Card?){
        var cards = finalCards
        var checkedSuit:Suit!
        
        if (isFlush().0){
            if let card = isFlush().1{
                checkedSuit = card.suit
            }
        }
        else{
            return (false, nil)
        }
        
        //rearrange cards without duplicate ranks
        var indexToRemove = [Int]()
        for i in 0..<cards.count-1{
            if cards[i].rank == cards[i+1].rank{
                if cards[i].suit == checkedSuit{
                    indexToRemove.append(i+1)
                }
                else{
                    indexToRemove.append(i)
                }
            }
        }
        if indexToRemove.count > 0{
            var newCards = [Card]()
            for i in 0...cards.count-1{
                if !indexToRemove.contains(i){
                    newCards.append(cards[i])
                }
            }
            cards = newCards
        }
        
        //if there is less than 5 cards, it cannot be a Straight
        if cards.count < 5{
            return (false, nil)
        }
        
        //to make shure not to be out of index
        let maxStartPosition = cards.count - 4
        var straightCards:[Card]?
        for i in 0..<maxStartPosition{
            let compare1 = finalCards[i] << finalCards[i+1]
            let compare2 = finalCards[i+1] << finalCards[i+2]
            let compare3 = finalCards[i+2] << finalCards[i+3]
            let compare4 = finalCards[i+3] << finalCards[i+4]
            
            if compare1 && compare2 && compare3 && compare4{
                straightCards = [cards[i], cards[i+1], cards[i+2], cards[i+3], cards[i+4]]
            }
        }
        
        if straightCards != nil{
            return (isSameSuit(cards!).0, isSameSuit(cards!).1)
        }
        return (false, nil)
    }
    
    func isRoyalFlush() -> Bool{
        if !(isFlush().0){
            return false
        }
        var rankChecker = 10
        var cards = [Card]()
        
        for card in finalCards{
            if card.rank == rankChecker{
                rankChecker += 1
                cards.append(card)
            }
        }
        if rankChecker == 14{
            if (isSameSuit(cards).0){
                return true
            }
            else{ return false }
        }
        else{ return false }
    }
    
    func isSameSuit(cards:[Card]) -> (Bool, Card?){
        var spadesCount = 0
        var heartCount = 0
        var diamondCount = 0
        var clubsCount = 0
        var highCard:Card?
        
        for card in cards{
            switch card.suit.shortName {
            case "c":
                clubsCount += 1
                if clubsCount >= 5{
                    highCard = card
                }
            case "d":
                diamondCount += 1
                if diamondCount >= 5{
                    highCard = card
                }
            case "h":
                heartCount += 1
                if heartCount >= 5{
                    highCard = card
                }
            case "s":
                spadesCount += 1
                if spadesCount >= 5{
                    highCard = card
                }
            default:
                break
            }
        }
        
        if let highCard = highCard{
            return (true, highCard)
        }
        else{ return (false, nil) }
    }
}
