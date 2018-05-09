//
//  GameViewController.swift
//  Flappy Gator
//
//  Created by Peter Lin & Regine Manuel on 4/7/18.
//  Copyright © 2018 690FinalProject. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size) //instantiate game object
        let SKView = view as! SKView
        SKView.showsFPS = false
        SKView.showsNodeCount = false
        SKView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        SKView.presentScene(scene)
        
        }
    

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
