//
//  Card.swift
//  SixHandPoker
//
//  Created by zach bachar on 02/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import UIKit
import SpriteKit

class Card: SKSpriteNode{
    var rank:Rank!
    var suit:Suit!
    var faceUp = true
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.rank = nil
        self.suit = nil
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var backTexture:SKTexture{
        let tex = SKTexture(imageNamed: "cardstyle1back")
        return tex
    }
    
    var frontTexture:SKTexture{
        let tex =  SKTexture(image: self.image)
        return tex
    }
    
    var image:UIImage{
        return UIImage(named: "cardstyle1\(suit.shortName)\(rank.value)")!
    }
    
    var imageName:String{
        return "cardstyle1\(suit.shortName)\(rank.value)"
    }
    
    override var description: String{
        return "\(self.rank.description) of \(self.suit.description)"
    }
    
    private func flipSound() -> SKAction{
        return SKAction.playSoundFileNamed("cardPlace3", waitForCompletion: false)
    }
    
    func flip(wait:NSTimeInterval, complition:(() -> ())? ) {
        let firstHalfFlip = SKAction.scaleXTo(0.0, duration: 0.2)
        let secondHalfFlip = SKAction.scaleXTo(1.0, duration: 0.2)
        let wait = SKAction.waitForDuration(wait)
        
        runAction(wait){
            if self.faceUp {
                self.runAction(SKAction.sequence([firstHalfFlip, self.flipSound()])) {
                    self.texture = self.backTexture
                    self.faceUp = false
                    self.runAction(secondHalfFlip)
                }
            } else {
                self.runAction(SKAction.sequence([firstHalfFlip, self.flipSound()])) {
                    self.texture = self.frontTexture
                    self.faceUp = true
                    self.runAction(secondHalfFlip){
                        if let comp = complition{
                            comp()
                        }
                    }
                }
            }
        }
    }
}

//------------------- Operatros ------------------

func + (lhs:Card, rhs:Card) -> Int{
    let first = lhs.rank.value
    let second = rhs.rank.value
    return first + second <= 21 ? first + second : first + 1
}

func + (lhs:Int, rhs:Card) -> Int{
    return lhs + rhs.rank.value
}

func == (lhs:Card, rhs:Card) -> Bool{
    return ((lhs.suit.rawValue == rhs.suit.rawValue)
        && (lhs.rank.rawValue == rhs.rank.rawValue))
}


