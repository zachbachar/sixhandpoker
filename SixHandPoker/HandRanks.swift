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

extension Hand{
    func handScore(cards:[Card]) -> (Int, HandRanks, String){
        let handRank = checkHandRank(cards)
        print(finalCards)
        let rank = handRank.0
        let highCard = handRank.1.first!
        let message = handRank.2
        
        var handScore = rank.rawValue * highCard.rank.rawValue
        
        if rank == .TwoPairs || rank == .FullHouse{
           handScore += handRank.1.last!.rank.rawValue
        }
        /*
            if let card = handRank.1.last{
                handScore += handRank.1.last!.rank.rawValue
            }
        */
        
        
        return (handScore, rank, message)
    }
    
    func checkHandRank(cards:[Card]) -> (HandRanks, [Card], String){
        finalCards = cards
        finalCardsFromLowToHigh()
        
        if isRoyalFlush() != nil{
            return (.RoyalFlush, [finalCards.last!], "Royal Flush!")
        }
        else if let ans = isStraightFlush(){
            return (.StraightFlush, [ans.1], "Straight Flush Of \(ans.1.suit.description) To \(ans.1.rank.description)!")
        }
        else if let ans = isFourOfKind(){
            return (.FourOfKind, [ans.1], "Four Of A Kind Of \(ans.1.rank.description)!")
        }
        else if let ans = isFullHouse(){
            return (.FullHouse, [ans.1, ans.2], "House Of \(ans.1.rank.description) Filled With \(ans.2.rank.description)!")
        }
        else if let ans = isFlush(){
            return (.Flush, [ans.1], "Flush Of \(ans.1.suit.description)!")
        }
        else if let ans = isStraight(){
            return (.Straight, [ans.1], "Straight To \(ans.1.rank.description)!")
        }
        else if let ans = isThreeOfKind(){
            return (.ThreeOfKind, [ans.1], "Three Of \(ans.1.rank.description)!")
        }
        else if let ans = isTwoPairs(){
            return (.TwoPairs, [ans.1, ans.2], "Two Pairs Of \(ans.1.rank.description) And \(ans.2.rank.description)!")
        }else if let ans = isPair(){
            return (.Pair, [ans.1], "Pair Of \(ans.1.rank.description)!")
        }
        else{
            let ans = isHighCard()
            return (.HighCard, [ans.1], "High Card \(ans.1.rank.description)!")
        }
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func finalCardsFromLowToHigh() -> [Card]{
        finalCards.sortInPlace { (c1, c2) -> Bool in
            return c1.rank.rawValue < c2.rank.rawValue
        }
        return finalCards
    }
    
    func finalCardsFromHighToLow() -> [Card]{
        finalCards.sortInPlace { (c1, c2) -> Bool in
            return c1.rank.rawValue > c2.rank.rawValue
        }
        return finalCards
    }
    
    func removeFromFinalCards(indexs :[Int]){
        let toRemove = indexs.sort { (i, y) -> Bool in
            return i > y
        }
        for index in toRemove{
            finalCards.removeAtIndex(index)
        }
        
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isHighCard() -> (Bool, Card){
        finalCardsFromLowToHigh()
        let highCard = finalCards.removeLast()
        return (true, highCard)
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isPair() -> (Bool, Card)?{
        var cards = finalCardsFromHighToLow()
        let maxStartPosition = cards.count - 1
        for i in 0..<maxStartPosition{
            if cards[i].rank == cards[i+1].rank{
                let pairCard = finalCards[i+1]
                removeFromFinalCards([i, i+1])
                return (true, pairCard)
            }
        }
        return nil
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isTwoPairs() -> (Bool, Card, Card)?{
        var cards = finalCardsFromHighToLow()
        var pairsCount = 0
        var highPair:Card!
        let maxStartPosition = cards.count - 1
        for i in 0..<maxStartPosition{
            if cards[i].rank == cards[i+1].rank{
                pairsCount += 1
                if pairsCount == 1{
                    highPair = cards[i]
                }
                if pairsCount == 2{
                    let lowPair = cards[i]
                    var toRemove = [Int]()
                    for i in 0...cards.count-1{
                        if cards[i].rank == highPair.rank || cards[i].rank == lowPair.rank{
                            toRemove.append(i)
                        }
                    }
                    removeFromFinalCards(toRemove)
                    return (true, highPair, lowPair)
                }
            }
        }
        return nil
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isThreeOfKind() -> (Bool, Card)?{
        finalCardsFromLowToHigh()
        let maxStartPosition = finalCards.count - 2
        for i in 0..<maxStartPosition{
            if finalCards[i].rank == finalCards[i+1].rank && finalCards[i].rank == finalCards[i+2].rank{
                let threeKindCard = finalCards[i]
                removeFromFinalCards([i, i+1, i+2])
                return(true, threeKindCard)
            }
        }
        return nil
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isStraight() -> (Bool, Card)?{
        var cards = finalCardsFromLowToHigh()
        var indexToRemove = [Int]()
        for i in 0..<cards.count-1{
            if cards[i].rank == cards[i+1].rank{
                indexToRemove.append(i+1)
            }
        }
       
        if indexToRemove.count > 0{
            var newCards = [Card]()
            for i in 0..<cards.count-1{
                if !indexToRemove.contains(i){
                    newCards.append(cards[i])
                }
            }
            cards = newCards
        }
        
        if cards.count < 5{
            return nil
        }
        
        let maxStartPosition = finalCards.count - 4
        var highest:Card? = nil
        for i in 0..<maxStartPosition{
            let compare1 = finalCards[i] << finalCards[i+1]
            let compare2 = finalCards[i+1] << finalCards[i+2]
            let compare3 = finalCards[i+2] << finalCards[i+3]
            let compare4 = finalCards[i+3] << finalCards[i+4]
            
            if compare1 && compare2 && compare3 && compare4{
                if highest == nil{
                    highest = finalCards[i+4]
                }
                else if let h = highest{
                    if finalCards[i+4].rank > h.rank{
                        highest = finalCards[i+4]
                    }
                }
            }
        }
        if highest != nil{
            return (true, highest!)
        }
        
        var aceFlag = false
        for card in cards{
            if card.rank == Rank.Ace{
                card.rank = Rank.LowAce
                aceFlag = true
            }
        }
        if aceFlag{
            cards = finalCardsFromLowToHigh()
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
        
        return nil
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isFlush() -> (Bool, Card)?{
        finalCardsFromLowToHigh()
        var spadesCount = 0
        var heartCount = 0
        var diamondCount = 0
        var clubsCount = 0
        var highCard:Card? = nil
        
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
        
        var toRemove = [Int]()
        if highCard != nil{
            let cards = finalCardsFromLowToHigh()
            for i in 0...cards.count - 1{
                if cards[i].suit != highCard!.suit{
                    toRemove.append(i)
                }
                if cards[i].rank == highCard!.rank{
                    toRemove.append(i)
                }
            }
            removeFromFinalCards(toRemove)
            return (true, highCard!)
        }
        else{
            return nil
        }
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isFullHouse() -> (Bool, Card, Card)?{
        var cards = finalCardsFromHighToLow()
        let maxStartPosition = cards.count - 2
        var pairCard:Card! = nil
        var threeCard:Card! = nil
        
        for i in 0..<maxStartPosition{
            if cards[i].rank == cards[i+1].rank && cards[i].rank == cards[i+2].rank{
                threeCard = cards[i]
            }
            else if cards[i].rank == cards[i+1].rank{
                if threeCard == nil{
                    pairCard = cards[i]
                }
                else if let threeCard = threeCard{
                    if cards[i].rank != threeCard.rank{
                        pairCard = cards[i]
                    }
                }
            }
            else if cards[i+1].rank == cards[i+2].rank{
                if threeCard == nil{
                    pairCard = cards[i+1]
                }
                else if let threeCard = threeCard{
                    if cards[i+1].rank != threeCard.rank{
                        pairCard = cards[i+1]
                    }
                }
            }
        }
        
        var toRemove = [Int]()
        if pairCard != nil && threeCard != nil{
            for i in 0...cards.count - 1{
                if cards[i].rank == threeCard.rank || cards[i].rank == pairCard.rank{
                    toRemove.append(i)
                }
            }
            removeFromFinalCards(toRemove)
            return (true, threeCard, pairCard)
        }
        return nil
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isFourOfKind() -> (Bool, Card)?{
        finalCardsFromLowToHigh()
        let maxStartPosiotin = finalCards.count - 3
        for i in 0..<maxStartPosiotin{
            let compare1 = finalCards[i].rank == finalCards[i+1].rank
            let compare2 = finalCards[i].rank == finalCards[i+2].rank
            let compare3 = finalCards[i].rank == finalCards[i+3].rank
            
            if compare1 && compare2 && compare3{
                let fourKindCard = finalCards[i]
                removeFromFinalCards([i, i+1, i+2, i+3])
                return(true, fourKindCard)
            }
        }
        return nil
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isStraightFlush() -> (Bool, Card)?{
        var cards = finalCards
        var checkedSuit:Suit!
        
        if let ans = isSameSuit(cards){
            checkedSuit = ans.1.suit
        }
        else{
            return nil
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
            return nil
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
                if straightCards == nil{
                    straightCards = [cards[i], cards[i+1], cards[i+2], cards[i+3], cards[i+4]]
                }
                else if let cards = straightCards{
                    if finalCards[i+4].rank > cards.last!.rank{
                        straightCards = [cards[i], cards[i+1], cards[i+2], cards[i+3], cards[i+4]]
                    }
                }
                
            }
        }
        
        if straightCards != nil{
            if let ans = isSameSuit(cards!){
                return (ans.0, ans.1)
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
            cards = finalCardsFromLowToHigh()
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
                if let ans = isSameSuit(cards!){
                    return (ans.0, ans.1)
                }
            }
            else{
                for card in cards{
                    if card.rank == Rank.LowAce{
                        card.rank = Rank.Ace
                    }
                }
            }
        }

        return nil
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isRoyalFlush() -> Bool?{
        if isSameSuit(finalCards) == nil{
            return nil
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
            if isSameSuit(cards) != nil{
                return true
            }
            else{ return nil }
        }
        else{ return nil }
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isSameSuit(cards:[Card]) -> (Bool, Card)?{
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
        else{ return nil }
    }
}

/*--------------------------Operators--------------------------*/

func > (lhs:HandRanks, rhs:HandRanks) -> Bool{
    return lhs.rawValue > rhs.rawValue
}

func == (lhs:HandRanks, rhs:HandRanks) -> Bool{
    return lhs.rawValue == rhs.rawValue
}