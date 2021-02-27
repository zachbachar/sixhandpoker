//
//  mainSceneViewController.swift
//  SixHandPoker
//
//  Created by Zach Bachar on 30/11/2017.
//  Copyright © 2017 zach bachar. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let scene = GameScene(fileNamed: "GameScene"){
            let skView = self.view as! SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFit
            scene.viewController = self
            skView.presentScene(scene)
        }
        
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

