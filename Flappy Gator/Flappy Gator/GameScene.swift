//
//  GameScene.swift
//  Flappy Gator
//
//  Created by Peter Lin on 4/7/18.
//  Copyright © 2018 690FinalProject. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene , SKPhysicsContactDelegate{
    var isGameStarted = Bool(false)
    var isDied = Bool(false)
    
    var score = Int(0)
    var scoreLabel = SKLabelNode()
    var highscoreLabel = SKLabelNode()
    var taptoplayLabel = SKSpriteNode()
    var restartButton = SKSpriteNode()
    var pauseButton = SKSpriteNode()
    var logoImage = SKSpriteNode()
    var wallPair = SKNode()
    var moveAndRemove = SKAction()
    
    
    //Create the gator atlas for animation
    let gatorAtlas = SKTextureAtlas(named:"player")
    var gatorSprites = Array<Any>()
    var gator = SKSpriteNode()
    var repeatActionBird = SKAction()
 
    
    override func didMove(to view: SKView){
        createScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval){
            //called before each frame is rendered
        if isGameStarted == true{
            if isDied == false{
                enumerateChildNodes(withName: "background", using: ({
                    (node, error) in
                    let background = node as! SKSpriteNode
                    background.position = CGPoint(x: background.position.x - 2, y: background.position.y)
                    if background.position.x <= -background.size.width {
                        background.position = CGPoint(x:background.position.x + background.size.width * 2, y:background.position.y)
                    }
                }))
            }
        }
    }
    
    func createScene(){
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)                  //create a physics body around entire scene
        self.physicsBody?.categoryBitMask = CollisionBitMask.groundCategory         //defines which categories this physics body belongs to
        self.physicsBody?.collisionBitMask = CollisionBitMask.gatorCategory         //defines which categories of physics can collide with this physics body
        self.physicsBody?.contactTestBitMask = CollisionBitMask.gatorCategory       //defines which categories of bodies cause intersection notifications with this physics body
        self.physicsBody?.isDynamic = false
        self.physicsBody?.affectedByGravity = false                                 //prevents player from falling off the scene
        
        self.physicsWorld.contactDelegate = self
        //self.backgroundColor = SKColor(red: 80.0/225, green: 192.0/225, blue: 203.0/225)
        
    
    
        for i in 0..<2{
            let background = SKSpriteNode(imageNamed: "background")
            background.anchorPoint = CGPoint.init(x: 0, y: 0)
            background.position = CGPoint(x:CGFloat(i) * self.frame.width, y: 0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)
        }
        gatorSprites.append(gatorAtlas.textureNamed("gator"))                           //add sprites to the gator atlas
    
        self.gator = createGator()
        self.addChild(gator)
    
        scoreLabel = createScoreLabel()
        self.addChild(scoreLabel)
        
        highscoreLabel = createHighScoreLabel()
        self.addChild(highscoreLabel)
        
        createLogo()
        
        createTapToPlayLabel()

    
    }
}
