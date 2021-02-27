//
//  AddSpriteNodes.swift
//  SixHandPoker
//
//  Created by Zach Bachar on 29/11/2017.
//  Copyright © 2017 zach bachar. All rights reserved.
//

import UIKit
import SpriteKit

extension MenuScene{
    
    func addScroll(){
        let scroll = SKSpriteNode(imageNamed: "scroll")
        scroll.name = "scroll"
        //scroll.xScale = 0.4
        //scroll.yScale = 0.4
        scroll.alpha = 0
        scroll.position = CGPoint(x: midX, y: midY + 150)
        scroll.zPosition = 2
        addChild(scroll)
    }
    
    func addTitle(){
        let title = SKSpriteNode(imageNamed: "title")
        title.name = "title"
        //title.xScale = 0.4
        //title.yScale = 0.4
        title.alpha = 0
        title.position = CGPoint(x: midX, y: midY + 150)
        title.zPosition = 4
        addChild(title)
    }
    
    func addButtons(){
        let startBtn = SKSpriteNode(imageNamed: "startBtn")
        startBtn.name = "startBtn"
        startBtn.xScale = 0.35
        startBtn.yScale = 0.35
        startBtn.alpha = 0
        startBtn.zPosition = 2
        startBtn.position = CGPoint(x: midX, y: midY - 250)
        addChild(startBtn)
        
        let optionsBtn = SKSpriteNode(imageNamed: "optionsBtn")
        optionsBtn.name = "optionsBtn"
        optionsBtn.xScale = 0.3
        optionsBtn.yScale = 0.3
        optionsBtn.alpha = 0
        optionsBtn.zPosition = 2
        optionsBtn.position = CGPoint(x: midX - startBtn.frame.width, y: midY - 250)
        addChild(optionsBtn)
        
        let tutorialBtn = SKSpriteNode(imageNamed: "tutorialBtn")
        tutorialBtn.name = "tutorialBtn"
        tutorialBtn.xScale = 0.3
        tutorialBtn.yScale = 0.3
        tutorialBtn.alpha = 0
        tutorialBtn.zPosition = 2
        tutorialBtn.position = CGPoint(x: midX + startBtn.frame.width, y: midY - 250)
        addChild(tutorialBtn)
    }
}
