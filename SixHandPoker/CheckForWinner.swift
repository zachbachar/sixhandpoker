//
//  CheckForWinner.swift
//  SixHandPoker
//
//  Created by Zach Bachar on 29/11/2017.
//  Copyright © 2017 zach bachar. All rights reserved.
//

import SpriteKit

extension GameScene{
    
    func checkForWinner(){
        var results = [user.handValue(self.cardsOnTable),
                       opponent.handValue(self.cardsOnTable),
                       dealer.handValue(self.cardsOnTable)]
        
        print("User: \(results[0].3) - score: \(results[0].1)")
        print("Opp: \(results[1].3) - score: \(results[1].1)")
        print("Dealer: \(results[2].3) - score: \(results[2].1)")
        
        let temp = results.sorted { (x, y) -> Bool in
            return x.1 > y.1
        }
        
        results = temp
        
        //Tie Handeling
        if results[0].1 == results[1].1{
            if results[0].2 == .straight || results[0].2 == .straightFlush{
                animateWinnerCards(nil, kicker: nil)
                return
            }
            else {
                var p1Cards = results[0].0.hands.first!.finalCards
                var p2Cards = results[1].0.hands.first!.finalCards
                
                p1Cards?.sort(by: { (c1, c2) -> Bool in
                    return c1.rank.rawValue > c2.rank.rawValue
                })
                p2Cards?.sort(by: { (c1, c2) -> Bool in
                    return c1.rank.rawValue > c2.rank.rawValue
                })
                
                repeat{
                    if (p1Cards?.first!.rank)! > (p2Cards?.first!.rank)!{
                        animateWinnerCards(results[0], kicker: p1Cards?.first!)
                        return
                    }
                    if (p1Cards?.first!.rank)! < (p2Cards?.first!.rank)!{
                        animateWinnerCards(results[1], kicker: p2Cards?.first!)
                        return
                    }
                    p1Cards?.removeFirst()
                    p2Cards?.removeFirst()
                } while ((p1Cards?.count)! > 2)
                animateWinnerCards(nil, kicker: nil)
                return
            }
        }
        animateWinnerCards(results[0], kicker: nil)
    }
}
