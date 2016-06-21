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
    case TwoPairs = 38
    case ThreeOfKind = 267
    case Straight = 748
    case Flush = 1497
    case FullHouse = 6987
    case FourOfKind = 48910
    case StraightFlush = 136949
    case RoyalFlush = 383458
    
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

extension Hand{
    func handScore(cards:[Card]) -> (Int, HandRanks){
        let handRank = checkHandRank(cards)
        let rank = handRank.0
        let highCard = handRank.1
        //let message = handRank.2
        
        let handScore = rank.rawValue * highCard.rank.rawValue
        
        return (handScore, rank)
    }
    
    func checkHandRank(cards:[Card]) -> (HandRanks, Card, String){
        finalCards = cards
        finalCards.sortInPlace { (c1, c2) -> Bool in
            return c1.rank.rawValue < c2.rank.rawValue
        }
        
        if isRoyalFlush(){
            return (.RoyalFlush, finalCards.last!, "Royal Flush!")
        }
        else if isStraightFlush().0{
            return (.StraightFlush, isStraightFlush().1!, "Straight Flush Of \(isStraightFlush().1!.suit.description) To \(isStraightFlush().1!.rank.description)!")
        }
        else if isFourOfKind().0{
            return (.FourOfKind, isFourOfKind().1!, "Four Of A Kind Of \(isFourOfKind().1!.rank.description)!")
        }
        else if isFullHouse().0{
            return (.FullHouse, isFullHouse().1!, "House Of \(isFullHouse().1!.rank.description) Filled With \(isFullHouse().2!.rank.description)!")
        }
        else if isFlush().0{
            return (.Flush, isFlush().1!, "Flush Of \(isFlush().1!.suit.description)!")
        }
        else if isStraight().0{
            return (.Straight, isStraight().1!, "Straight To \(isStraight().1!.rank.description)!")
        }
        else if isThreeOfKind().0{
            return (.ThreeOfKind, isThreeOfKind().1!, "Three Of \(isThreeOfKind().1!.rank.description)!")
        }
        else if isTwoPairs().0{
            return (.TwoPairs, isTwoPairs().1!, "Two Pairs Of \(isTwoPairs().1!.rank.description) And \(isTwoPairs().2!.rank.description)!")
        }else if isPair().0{
            return (.Pair, isPair().1!, "Pair Of \(isPair().1!.rank.description)!")
        }
        else{
            return (.HighCard, isHighCard().1!, "High Card \(isHighCard().1!.rank.description)!")
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
    
    func isTwoPairs() -> (Bool, Card?, Card?){
        var pairsCount = 0
        var firstPair:Card!
        let maxStartPosition = finalCards.count - 1
        for i in 0..<maxStartPosition{
            if finalCards[i].rank == finalCards[i+1].rank{
                pairsCount += 1
                if pairsCount == 1{
                    firstPair = finalCards[i]
                }
                if pairsCount == 2{
                    return (true, finalCards[i], firstPair)
                }
            }
        }
        return (false, nil, nil)
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
        
        var aceFlag = false
        for card in cards{
            if card.rank == Rank.Ace{
                card.rank = Rank.LowAce
                aceFlag = true
            }
        }
        if aceFlag{
            cards.sortInPlace { (c1, c2) -> Bool in
                return c1.rank.rawValue < c2.rank.rawValue
            }
            for i in 0..<maxStartPosition{
                let compare1 = finalCards[i] << finalCards[i+1]
                let compare2 = finalCards[i+1] << finalCards[i+2]
                let compare3 = finalCards[i+2] << finalCards[i+3]
                let compare4 = finalCards[i+3] << finalCards[i+4]
                
                if compare1 && compare2 && compare3 && compare4{
                    return (true, finalCards[i+4])
                }
                else{
                    for card in cards{
                        if card.rank == Rank.LowAce{
                            card.rank = Rank.Ace
                        }
                    }
                }
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
    
    func isFullHouse() -> (Bool, Card?, Card?){
        if let pairCard = isPair().1{
            if let threeCard = isThreeOfKind().1{
                if pairCard.rank != threeCard.rank{
                    return (true, threeCard, pairCard)
                }
            }
        }
        return (false, nil, nil)
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
        
        var aceFlag = false
        for card in cards{
            if card.rank == Rank.Ace{
                card.rank = Rank.LowAce
                aceFlag = true
            }
        }
        if aceFlag{
            cards.sortInPlace { (c1, c2) -> Bool in
                return c1.rank.rawValue < c2.rank.rawValue
            }
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
            else{
                for card in cards{
                    if card.rank == Rank.LowAce{
                        card.rank = Rank.Ace
                    }
                }
            }
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

/*--------------------------Operators--------------------------*/

func > (lhs:HandRanks, rhs:HandRanks) -> Bool{
    return lhs.rawValue > rhs.rawValue
}

func == (lhs:HandRanks, rhs:HandRanks) -> Bool{
    return lhs.rawValue == rhs.rawValue
}