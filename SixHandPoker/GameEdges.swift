//
//  GameEdges.swift
//  SixHandPoker
//
//  Created by Zach Bachar on 29/11/2017.
//  Copyright © 2017 zach bachar. All rights reserved.
//

import SpriteKit

extension GameScene{
    
    func resetGame() -> SKAction{
        deck = Deck()
        user.hands.removeAll()
        dealer.hands.removeAll()
        opponent.hands.removeAll()
        cardsOnTable.removeAll()
        initGame()
        initFirstDraw()
        canPlay = true
        return SKAction()
    }
    
    func initGame(){
        deck.shuffle()
        for _ in 0..<6{
            user.hands.append(Hand(card1: deck.drawCard()))
            opponent.hands.append(Hand(card1: deck.drawCard()))
        }
        for i in 0..<6{
            user.hands[i].card2 = deck.drawCard()
            opponent.hands[i].card2 = deck.drawCard()
        }
        for _ in 0..<5{
            cardsOnTable.append(deck.drawCard())
        }
    }
    
    func endGame(){
        canPlay = false
        round = 0
        checkForWinner()
        addNewGameButton()
        addMenuBtn()
    }
    
    func moveToMenuScene(){
        let menuBtn = childNode(withName: "menuBtn")!
        let action = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()])
        let menuScene = MenuScene(fileNamed:"MenuScene")!
        menuScene.scaleMode = .aspectFit
        menuBtn.run(action) {
            self.viewController?.performSegue(withIdentifier: "menuSegue", sender: Any?.self)
        }
    }
}
