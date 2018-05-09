//
//  GameElements.swift
//  Flappy Gator
//
//  Created by Peter Lin & Regine Manuel on 4/7/18.
//  Copyright © 2018 690FinalProject. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let gatorCategory:UInt32 = 0x1 << 0
    static let pipeCategory:UInt32 = 0x1 << 1
    static let scoreCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
}

extension GameScene {
    //create gator sprite with its properties
    func createGator() -> SKSpriteNode{
        
        //create a sprite of the gator with height/width of 50. Make it start in centered position
        let gator = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("gator"))
        gator.size = CGSize(width: 60, height: 60)
        gator.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 100)
        
        //have the gator sprite have a physics body of a circle with radius of half its width
        gator.physicsBody = SKPhysicsBody(circleOfRadius: gator.size.width / 2)
        gator.physicsBody?.linearDamping = 1.1
        gator.physicsBody?.restitution = 0
        
        //assign contact and collision bit masks to the pipe, ground and gator sprite
        gator.physicsBody?.categoryBitMask = CollisionBitMask.gatorCategory
        gator.physicsBody?.collisionBitMask = CollisionBitMask.pipeCategory | CollisionBitMask.groundCategory
        gator.physicsBody?.contactTestBitMask = CollisionBitMask.pipeCategory | CollisionBitMask.scoreCategory | CollisionBitMask.groundCategory
        
        //gator is affect by gravity
        gator.physicsBody?.affectedByGravity = false
        gator.physicsBody?.isDynamic = true
        
        return gator
    }
    
    //create a restart button
    func createRestartButton() {
        restartButton = SKSpriteNode(imageNamed:"restart")
        restartButton.size = CGSize(width:100, height:100)
        restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartButton.zPosition = 6
        restartButton.setScale(0)
        self.addChild(restartButton)
        restartButton.run(SKAction.scale(to :1.0, duration: 0.3))
    }
    
    //create a label to keep track of the score
    func createScoreLabel() -> SKLabelNode {
        let scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 3
        scoreLabel.fontSize = 40
        scoreLabel.fontColor = UIColor(red: CGFloat(255/255), green: CGFloat(255/255), blue: CGFloat(255/255), alpha: CGFloat(1))
        scoreLabel.fontName = "HelveticaNeue"
        
        let scoreBackground = SKShapeNode()
        scoreBackground.position = CGPoint(x: 0, y: 0)
        
        scoreBackground.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        
        scoreBackground.strokeColor = UIColor.clear
        scoreBackground.zPosition = -1
        scoreLabel.addChild(scoreBackground)
        
        return scoreLabel
        
    }
    
    //create highschore label
    func createHighScoreLabel() ->SKLabelNode {
        let highScoreLabel = SKLabelNode()
        highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height - 150)
        
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
            highscoreLabel.text = "Highest Score: \(highestScore)"
        }
        else {
            highScoreLabel.text = "Highest Score: 0"
        }
        
        highScoreLabel.zPosition = 5
        highScoreLabel.fontSize = 30
        highScoreLabel.fontName = "Helvetica-Bold"
        
        return highScoreLabel
    }
    
    //create logo
    func createLogo() {
        logoImage = SKSpriteNode()
        logoImage = SKSpriteNode(imageNamed: "logo")
        logoImage.size = CGSize(width: 272, height: 81.25)
        logoImage.position = CGPoint(x: self.frame.midX, y:self.frame.midY + 180)
        //logoImage.setScale(0.5)
        self.addChild(logoImage)
        logoImage.run(SKAction.scale(to:1.0, duration: 3.0))
    }
    
    func createGameOver() {
        gameOverImage = SKSpriteNode()
        gameOverImage = SKSpriteNode(imageNamed: "gameOver")
        gameOverImage.size = CGSize(width: 272, height: 81.25)
        gameOverImage.position = CGPoint(x: self.frame.midX, y:self.frame.midY + 90)
        self.addChild(gameOverImage)
        gameOverImage.zPosition = 6
        gameOverImage.run(SKAction.scale(to:1.0, duration: 3.0))
    }
    
    //create the play button and position it
    func createTapToPlayLabel() {
        tapToPlayLabel = SKSpriteNode()
        tapToPlayLabel = SKSpriteNode(imageNamed: "playButton")
        tapToPlayLabel.size = CGSize(width: 75, height: 75)
        tapToPlayLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        tapToPlayLabel.setScale(1.5)
        self.addChild(tapToPlayLabel)
        
    }
    
    func createPipes() -> SKNode {
        
        pipePair = SKNode()
        pipePair.name = "pipePair"
        
        let topPipe = SKSpriteNode(imageNamed: "pipeDown")
        let bottomPipe = SKSpriteNode(imageNamed: "pipeUp")
        let scoreCounter = SKSpriteNode(imageNamed: "count")
        
        topPipe.position = CGPoint(x: self.frame.width + 60, y: self.frame.height / 2 + 420)
        bottomPipe.position = CGPoint(x: self.frame.width + 60, y:self.frame.height / 2 - 420)
        scoreCounter.position = CGPoint(x: self.frame.width + 150, y:self.frame.height / 2)
        
        topPipe.setScale(0.5)
        bottomPipe.setScale(0.5)
        //scoreCounter.setScale(0.5)
        
        //assign the top/bottom pipe with physics and collision detection
        topPipe.physicsBody = SKPhysicsBody(rectangleOf: topPipe.size)
        topPipe.physicsBody?.categoryBitMask = CollisionBitMask.pipeCategory
        topPipe.physicsBody?.collisionBitMask = CollisionBitMask.gatorCategory
        topPipe.physicsBody?.contactTestBitMask = CollisionBitMask.gatorCategory
        topPipe.physicsBody?.isDynamic = false
        topPipe.physicsBody?.affectedByGravity = false
        
        bottomPipe.physicsBody = SKPhysicsBody(rectangleOf: bottomPipe.size)
        bottomPipe.physicsBody?.categoryBitMask = CollisionBitMask.pipeCategory
        bottomPipe.physicsBody?.collisionBitMask = CollisionBitMask.gatorCategory
        bottomPipe.physicsBody?.contactTestBitMask = CollisionBitMask.gatorCategory
        bottomPipe.physicsBody?.isDynamic = false
        bottomPipe.physicsBody?.affectedByGravity = false
        
        //add invisible pipe to count the score
        scoreCounter.physicsBody = SKPhysicsBody(rectangleOf: scoreCounter.size)
        scoreCounter.physicsBody?.categoryBitMask = CollisionBitMask.scoreCategory
        scoreCounter.physicsBody?.contactTestBitMask = CollisionBitMask.gatorCategory
        scoreCounter.physicsBody?.isDynamic = false
        scoreCounter.physicsBody?.affectedByGravity = false
        
        
        pipePair.addChild(topPipe)
        pipePair.addChild(bottomPipe)
        pipePair.addChild(scoreCounter)
        
        pipePair.zPosition = 1
        
        //re-adjust the pipe pairs so they are "random"
        let randomPosition = random(min: -200, max: 200)
        pipePair.position.y = pipePair.position.y + randomPosition
        
        pipePair.run(moveAndRemove)
        
        return pipePair
        
    }
    
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
        
        }
    
    
    
}
