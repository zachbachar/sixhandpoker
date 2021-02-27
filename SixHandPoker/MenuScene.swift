//
//  MenuScene.swift
//  SixHandPoker
//
//  Created by zach bachar on 08/06/2016.
//  Copyright © 2016 zach bachar. All rights reserved.
//

import UIKit
import SpriteKit

class MenuScene: SKScene {
    var viewContorller:UIViewController?
    var midX = CGFloat()
    var midY = CGFloat()
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        midX = self.frame.midX
        midY = self.frame.midY
        self.addScroll()
        self.addTitle()
        self.addButtons()
        self.animateMenuScene()
    }
    
    var touched:SKNode?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        if touchedNode.name == "startBtn"{
            //moveToGameScene()
            touched = touchedNode
            touchedNode.run(SKAction.scale(by: 1.25, duration: 0.05))
        }
        if touchedNode.name == "tutorialBtn"{
            //moveToGameScene()
            touched = touchedNode
            touchedNode.run(SKAction.scale(by: 1.25, duration: 0.05))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        //let touchedNode = nodeAtPoint(location)
        guard let touching = touched else {return}
        if !touching.frame.contains(location){
            touching.run(SKAction.scale(by: 0.8, duration: 0.05))
            touched = nil
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        if touchedNode.name == "startBtn"{
            touchedNode.run(SKAction.scale(by: 0.8, duration: 0.05))
            touched = nil
            moveToGameScene()
        }
        if touchedNode.name == "tutorialBtn"{
            touchedNode.run(SKAction.scale(by: 0.8, duration: 0.05))
            touched = nil
            moveToTutorialScene()
        }
    }
    
    func moveToGameScene(){
        let chip = childNode(withName: "startBtn")!
        let flyAway = SKAction.group([SKAction.moveTo(y: (view?.frame.height)!+100, duration: 0.15), SKAction.repeat(SKAction.rotate(byAngle: CGFloat(Double.pi*2), duration: 0.2), count: 1)])
        let bounce = SKAction.sequence([SKAction.scale(by: 0.8, duration: 0.05), flyAway])
        let gameScene = GameScene(fileNamed:"GameScene")!
        gameScene.scaleMode = .aspectFit
        //let transition = SKTransition.crossFade(withDuration: 0.5)
        chip.run(SKAction.group([bounce, SKAction.playSoundFileNamed("cardFan2", waitForCompletion: false)]), completion: {
            //self.view?.presentScene(gameScene, transition: transition)
            self.viewContorller?.performSegue(withIdentifier: "mainSceneSegue", sender: Any?.self)
        })
    }
    
    func moveToTutorialScene(){
        self.viewContorller?.performSegue(withIdentifier: "tutorialSegue", sender: Any?.self)
    }
}
