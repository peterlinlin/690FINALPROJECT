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
    var tapToPlayLabel = SKSpriteNode()
    var restartButton = SKSpriteNode()
    var pauseButton = SKSpriteNode()
    var logoImage = SKSpriteNode()
    var pipePair = SKNode()
    var scoreCounter = SKNode()
    var moveAndRemove = SKAction()
    var gameOverImage = SKSpriteNode()
    
    
    //Create the gator atlas for animation
    let gatorAtlas = SKTextureAtlas(named:"player")
    var gatorSprites = Array<Any>()
    var gator = SKSpriteNode()
    var repeatActionGator = SKAction()
 
    
    override func didMove(to view: SKView){
        createScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameStarted == false {
            isGameStarted = true
            gator.physicsBody?.affectedByGravity = true
           
            //remove logo and play button when the game starts
            logoImage.run(SKAction.scale(to: 0.5, duration: 0.3), completion: {
                self.logoImage.removeFromParent()
            })
            
            tapToPlayLabel.removeFromParent()
            
            self.gator.run(repeatActionGator)
            
            //create pipes
            let spawn = SKAction.run({
                () in
                self.pipePair = self.createPipes()
                self.addChild(self.pipePair)
                //self.addChild(self.scoreCounter)
            })
            
            //delay when the pipes start appearing
            let delay = SKAction.wait(forDuration: 1.5)
            let spawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatForever(spawnDelay)
            self.run(spawnDelayForever)
            
            //distance between pipes and how fast they go
            let distance = CGFloat(self.frame.width + pipePair.frame.width)
            let movePipes = SKAction.moveBy(x: -distance - 80, y: 0, duration: TimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            gator.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            gator.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 75))
            
        }
        else{
            if isDied == false {
                gator.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                gator.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 75))
            }
        }
        
        for touch in touches{
            let location = touch.location(in: self)
            if isDied == true{
                if restartButton.contains(location){
                    if UserDefaults.standard.object(forKey: "highestScore") != nil {
                        let hscore = UserDefaults.standard.integer(forKey: "highestScore")
                        
                        if hscore < Int(scoreLabel.text!)!{
                            UserDefaults.standard.set(scoreLabel.text, forKey: "highestScore")
                        }
                    }
                        
                    else {
                        UserDefaults.standard.set(0, forKey: "highestScore")
                    }
                    restartScene()
                    
                }
            }
        }
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
    
        //initialize everything
        self.gator = createGator()
        self.addChild(gator)
        scoreLabel = createScoreLabel()
        self.addChild(scoreLabel)
        highscoreLabel = createHighScoreLabel()
        self.addChild(highscoreLabel)
        createLogo()
        createTapToPlayLabel()
    
    }
    
    //when game begins, detect collisions
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        //if the gator hits the ground or pipe he dies
        if firstBody.categoryBitMask == CollisionBitMask.gatorCategory &&
           secondBody.categoryBitMask == CollisionBitMask.pipeCategory ||
           firstBody.categoryBitMask == CollisionBitMask.pipeCategory &&
           secondBody.categoryBitMask == CollisionBitMask.gatorCategory ||
           firstBody.categoryBitMask == CollisionBitMask.gatorCategory &&
           secondBody.categoryBitMask == CollisionBitMask.groundCategory ||
           firstBody.categoryBitMask == CollisionBitMask.groundCategory &&
           secondBody.categoryBitMask == CollisionBitMask.gatorCategory {
            
            enumerateChildNodes(withName: "pipePair", using: ({(node, error) in
                node.speed = 0
                self.removeAllActions()
            }))
            
            //when he dies remove all action and show restart button
            if isDied == false{
                isDied = true
                createRestartButton()
                self.gator.removeAllActions()
                createGameOver()
            }
            highscoreLabel = createHighScoreLabel()
            self.addChild(highscoreLabel)
        
        }
        // score count
        
        else if firstBody.categoryBitMask == CollisionBitMask.gatorCategory && secondBody.categoryBitMask == CollisionBitMask.scoreCategory {
            score += 1
            scoreLabel.text = "\(score)"
            secondBody.node?.removeFromParent()
        }
        else if firstBody.categoryBitMask == CollisionBitMask.scoreCategory && secondBody.categoryBitMask == CollisionBitMask.gatorCategory {
            score += 1
            scoreLabel.text = "\(score)"
            firstBody.node?.removeFromParent()
        }
    }
    
    //restart the game and set everything to default
    func restartScene(){
        self.removeAllChildren()
        self.removeAllActions()
        isDied = false
        isGameStarted = false
        score = 0
        
        createScene()
        
    }
    
}
