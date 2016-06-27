//
//  HandScoreEvaluate.swift
//  SixHandPoker
//
//  Created by zach bachar on 26/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import UIKit

extension Hand{
    func handScore(cards:[Card]) -> (Int, HandRanks, String, [Card]){
        let handRank = checkHandRank(cards)
        print(finalCards)
        let rank = handRank.0
        let highCard = handRank.1.first!
        let message = handRank.2
        let winningCards = handRank.3
        
        var handScore = rank.rawValue * highCard.rank.rawValue
        
        if rank == .TwoPairs || rank == .FullHouse{
            handScore += handRank.1.last!.rank.rawValue
        }
        
        return (handScore, rank, message, winningCards)
    }
    
    func checkHandRank(cards:[Card]) -> (HandRanks, [Card], String, [Card]){
        finalCards = cards
        finalCardsFromLowToHigh()
        
        if let ans = isRoyalFlush(){
            return (.RoyalFlush, [finalCards.last!], "Royal Flush!", ans.1)
        }
        else if let ans = isStraightFlush(){
            return (.StraightFlush, [ans.1], "Straight Flush Of \(ans.1.suit.description) To \(ans.1.rank.description)!", ans.2)
        }
        else if let ans = isFourOfKind(){
            return (.FourOfKind, [ans.1], "Four Of A \(ans.1.rank.description)!", ans.2)
        }
        else if let ans = isFullHouse(){
            return (.FullHouse, [ans.1, ans.2], "House Of \(ans.1.rank.description) Filled With \(ans.2.rank.description)!", ans.3)
        }
        else if let ans = isFlush(){
            return (.Flush, [ans.1], "Flush Of \(ans.1.suit.description)!", ans.2)
        }
        else if let ans = isStraight(){
            return (.Straight, [ans.1], "Straight To \(ans.1.rank.description)!", ans.2)
        }
        else if let ans = isThreeOfKind(){
            return (.ThreeOfKind, [ans.1], "Three Of A \(ans.1.rank.description)!", ans.2)
        }
        else if let ans = isTwoPairs(){
            return (.TwoPairs, [ans.1, ans.2], "Two Pairs Of \(ans.1.rank.description) And \(ans.2.rank.description)!", ans.3)
        }else if let ans = isPair(){
            return (.Pair, [ans.1], "Pair Of \(ans.1.rank.description)!", ans.2)
        }
        else{
            let ans = isHighCard()
            return (.HighCard, [ans.1], "High Card \(ans.1.rank.description)!", [ans.1])
        }
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func finalCardsFromLowToHigh() -> [Card]{
        finalCards.sortInPlace { (c1, c2) -> Bool in
            return c1.rank < c2.rank
        }
        return finalCards
    }
    
    func finalCardsFromHighToLow() -> [Card]{
        finalCards.sortInPlace { (c1, c2) -> Bool in
            return c1.rank > c2.rank
        }
        return finalCards
    }
    
    func removeFromFinalCards(indexs :[Int]) -> [Card]{
        var removedCards = [Card]()
        let toRemove = indexs.sort { (i, y) -> Bool in
            return i > y
        }
        for index in toRemove{
            removedCards.append(finalCards.removeAtIndex(index))
        }
        return removedCards
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isHighCard() -> (Bool, Card){
        finalCardsFromLowToHigh()
        let highCard = finalCards.removeLast()
        return (true, highCard)
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isPair() -> (Bool, Card, [Card])?{
        var cards = finalCardsFromHighToLow()
        let maxStartPosition = cards.count - 1
        for i in 0..<maxStartPosition{
            if cards[i].rank == cards[i+1].rank{
                let pairCard = finalCards[i+1]
                let removed = removeFromFinalCards([i, i+1])
                return (true, pairCard, removed)
            }
        }
        return nil
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isTwoPairs() -> (Bool, Card, Card, [Card])?{
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
                    let removed = removeFromFinalCards(toRemove)
                    return (true, highPair, lowPair, removed)
                }
            }
        }
        return nil
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isThreeOfKind() -> (Bool, Card, [Card])?{
        finalCardsFromLowToHigh()
        let maxStartPosition = finalCards.count - 2
        for i in 0..<maxStartPosition{
            if finalCards[i].rank == finalCards[i+1].rank && finalCards[i].rank == finalCards[i+2].rank{
                let threeKindCard = finalCards[i]
                let removed = removeFromFinalCards([i, i+1, i+2])
                return(true, threeKindCard, removed)
            }
        }
        return nil
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isStraight() -> (Bool, Card, [Card])?{
        var cards = finalCardsFromLowToHigh()
        var indexes = [Int]()
        for i in 0..<cards.count-1{
            if cards[i].rank == cards[i+1].rank{
                indexes.append(i+1)
            }
        }

        if indexes.count > 0{
            let toRemove = indexes.sort { (i, y) -> Bool in
                return i > y
            }
            for index in toRemove{
                cards.removeAtIndex(index)
            }
            /*var newCards = [Card]()
            for i in 0..<cards.count-1{
                if !indexToRemove.contains(i){
                    newCards.append(cards[i])
                }
            }
            cards = newCards*/
        }
        
        if cards.count < 5{
            return nil
        }
        
        let maxStartPosition = cards.count - 4
        var highest:Card? = nil
        var straightCards = [Card]()
        for i in 0..<maxStartPosition{
            let compare1 = cards[i] << cards[i+1]
            let compare2 = cards[i+1] << cards[i+2]
            let compare3 = cards[i+2] << cards[i+3]
            let compare4 = cards[i+3] << cards[i+4]
            
            if compare1 && compare2 && compare3 && compare4{
                if highest == nil{
                    highest = cards[i+4]
                    straightCards = [cards[i], cards[i+1], cards[i+2], cards[i+3], cards[i+4]]
                }
                else if let h = highest{
                    if cards[i+4].rank > h.rank{
                        highest = cards[i+4]
                        straightCards = [cards[i], cards[i+1], cards[i+2], cards[i+3], cards[i+4]]
                    }
                }
            }
        }
        if highest != nil{
            return (true, highest!, straightCards)
        }
        
        var aceFlag = false
        for card in cards{
            if card.rank == Rank.Ace{
                card.rank = Rank.LowAce
                aceFlag = true
            }
        }
        if aceFlag{
            cards.sortInPlace({ (c1, c2) -> Bool in
                return c1.rank.rawValue > c2.rank.rawValue
            })
            for i in 0..<maxStartPosition{
                let compare1 = cards[i] << cards[i+1]
                let compare2 = cards[i+1] << cards[i+2]
                let compare3 = cards[i+2] << cards[i+3]
                let compare4 = cards[i+3] << cards[i+4]
                
                if compare1 && compare2 && compare3 && compare4{
                    straightCards = [cards[i], cards[i+1], cards[i+2], cards[i+3], cards[i+4]]
                    return (true, cards[i+4], straightCards)
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
    
    func isFlush() -> (Bool, Card, [Card])?{
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
        var flushCards = [Card]()
        if highCard != nil{
            let cards = finalCardsFromLowToHigh()
            for i in 0...cards.count - 1{
                if cards[i].suit != highCard!.suit{
                    toRemove.append(i)
                }
                else{
                    flushCards.append(cards[i])
                }
                if cards[i].rank == highCard!.rank{
                    toRemove.append(i)
                    flushCards.append(cards[i])
                }
            }
            flushCards.sortInPlace({ (c1, c2) -> Bool in
                return c1.rank < c2.rank
            })
            while flushCards.count > 5 {
                flushCards.removeFirst()
            }
            removeFromFinalCards(toRemove)
            return (true, highCard!, flushCards)
        }
        else{
            return nil
        }
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isFullHouse() -> (Bool, Card, Card, [Card])?{
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
            else if i == maxStartPosition - 1{
                if cards[i+1].rank == cards[i+2].rank{
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
        }
        
        var toRemove = [Int]()
        if pairCard != nil && threeCard != nil{
            for i in 0...cards.count - 1{
                if cards[i].rank == threeCard.rank || cards[i].rank == pairCard.rank{
                    toRemove.append(i)
                }
            }
            let removed = removeFromFinalCards(toRemove)
            return (true, threeCard, pairCard, removed)
        }
        return nil
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isFourOfKind() -> (Bool, Card, [Card])?{
        finalCardsFromLowToHigh()
        let maxStartPosiotin = finalCards.count - 3
        for i in 0..<maxStartPosiotin{
            let compare1 = finalCards[i].rank == finalCards[i+1].rank
            let compare2 = finalCards[i].rank == finalCards[i+2].rank
            let compare3 = finalCards[i].rank == finalCards[i+3].rank
            
            if compare1 && compare2 && compare3{
                let fourKindCard = finalCards[i]
                let removed = removeFromFinalCards([i, i+1, i+2, i+3])
                return(true, fourKindCard, removed)
            }
        }
        return nil
    }
    
    /*----------------------------------------------------------------------------------------------------------------*/
    
    func isStraightFlush() -> (Bool, Card, [Card])?{
        var cards = finalCardsFromLowToHigh()
        var checkedSuit:Suit!
        
        if let ans = isSameSuit(cards){
            checkedSuit = ans.1.suit
        }
        else{
            return nil
        }
        
        //rearrange cards without duplicate ranks
        var indexes = [Int]()
        for i in 0..<cards.count-1{
            if cards[i].rank == cards[i+1].rank{
                if cards[i].suit == checkedSuit{
                    indexes.append(i+1)
                }
                else{
                    indexes.append(i)
                }
            }
        }
        if indexes.count > 0{
            let toRemove = indexes.sort { (i, y) -> Bool in
                return i > y
            }
            for index in toRemove{
                cards.removeAtIndex(index)
            }
        }
        
        //if there is less than 5 cards, it cannot be a Straight
        if cards.count < 5{
            return nil
        }
        
        //to make shure not to be out of index
        let maxStartPosition = cards.count - 4
        var straightCards:[Card]?
        for i in 0..<maxStartPosition{
            let compare1 = cards[i] << cards[i+1]
            let compare2 = cards[i+1] << cards[i+2]
            let compare3 = cards[i+2] << cards[i+3]
            let compare4 = cards[i+3] << cards[i+4]
            
            if compare1 && compare2 && compare3 && compare4{
                if straightCards == nil{
                    straightCards = [cards[i], cards[i+1], cards[i+2], cards[i+3], cards[i+4]]
                }
                else if let oldStraightCards = straightCards{
                    if cards[i+4].rank > oldStraightCards.last!.rank{
                        straightCards = [cards[i], cards[i+1], cards[i+2], cards[i+3], cards[i+4]]
                    }
                }
                
            }
        }
        
        if straightCards != nil{
            if let ans = isSameSuit(cards){
                return (ans.0, ans.1, straightCards!)
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
            cards.sortInPlace({ (c1, c2) -> Bool in
                return c1.rank.rawValue > c2.rank.rawValue
            })
            for i in 0..<maxStartPosition{
                let compare1 = cards[i] << cards[i+1]
                let compare2 = cards[i+1] << cards[i+2]
                let compare3 = cards[i+2] << cards[i+3]
                let compare4 = cards[i+3] << cards[i+4]
                
                if compare1 && compare2 && compare3 && compare4{
                    straightCards = [cards[i], cards[i+1], cards[i+2], cards[i+3], cards[i+4]]
                }
            }
            
            if straightCards != nil{
                if let ans = isSameSuit(cards){
                    return (ans.0, ans.1, straightCards!)
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
    
    func isRoyalFlush() -> (Bool, [Card])?{
        if let straightFlush = isStraightFlush(){
            let highCard = straightFlush.1
            if highCard.rank == .Ace{
                return (true, straightFlush.2)
            }
        }
        
        return nil
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