//
//  Deck.swift
//  SixHandPoker
//
//  Created by zach bachar on 02/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import UIKit
import SpriteKit

struct Deck:CustomStringConvertible {
    
    var deck:[Card] = []
    
    init() {
        for i in 1...4{
            for y in 1...13{
                if let s = Suit(rawValue: i), let r = Rank(rawValue: y){
                    let tex = SKTexture(imageNamed: "cardstyle1\(s.shortName)\(r.value)")
                    let card = Card(texture: tex, color: UIColor.clearColor(), size: tex.size())
                    card.suit = s
                    card.rank = r
                    deck.append(card)
                }
            }
        }
    }
    
    mutating func shuffle(){
        for _ in 1...3{
            deck.sortInPlace{(num1, num2)  -> Bool in
                var rand = 0
                arc4random_buf(&rand, sizeof(Int))
                return rand % 2 == 0
            }
        }
    }
    
    mutating func drawCard() -> Card{
        return deck.removeLast()
    }
    
    var description:String{
        return "\(deck) Deck Count: \(deck.count)"
    }
    
    var count:Int{
        return deck.count
    }
}