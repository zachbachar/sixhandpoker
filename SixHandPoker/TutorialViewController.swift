//
//  TutorialViewController.swift
//  SixHandPoker
//
//  Created by Zach Bachar on 30/11/2017.
//  Copyright © 2017 zach bachar. All rights reserved.
//

import UIKit
import AVFoundation

class TutorialViewController: UIViewController{
    
    var audioPlayer = AVAudioPlayer()
    let tutorials = [UIImage(named: "tuto1"), UIImage(named: "tuto2"), UIImage(named: "tuto3"), UIImage(named: "tuto4"),
                     UIImage(named: "tuto5"), UIImage(named: "tuto6"), UIImage(named: "tuto7"), UIImage(named: "tuto8"), UIImage(named: "tuto9")]
    @IBOutlet weak var tutorialImageView: UIImageView!
    var tutorialStatus = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initAudioPlayer()
    }
    @IBAction func nextBtnTouched(_ sender: UIButton) {
        changeTutorialScreen()
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func initAudioPlayer(){
        let music = Bundle.main.path(forResource: "chipsStack4", ofType: "wav")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: music! ))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch{
            print(error)
        }
    }
    
    func changeTutorialScreen(){
        tutorialImageView.image = tutorials[tutorialStatus]
        audioPlayer.play()
        if tutorialStatus >= 8{
            tutorialStatus = 0
        } else{
            tutorialStatus += 1
        }
    }
    
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
	return input.rawValue
}
