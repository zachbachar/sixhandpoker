//
//  GameViewController.swift
//  SixHandPoker
//
//  Created by zach bachar on 02/06/2016.
//  Copyright (c) 2016 zach bachar. All rights reserved.
//

import UIKit
import SpriteKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        /*if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            //skView.showsFPS = true
            //skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }*/
        
        if let scene = MenuScene(fileNamed: "MenuScene"){
            let skView = self.view as! SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFit
            scene.viewContorller = self
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
