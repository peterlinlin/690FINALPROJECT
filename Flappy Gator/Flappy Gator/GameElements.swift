//
//  GameElements.swift
//  Flappy Gator
//
//  Created by Peter Lin on 4/7/18.
//  Copyright © 2018 690FinalProject. All rights reserved.
//

import SpriteKit

struct CollisionBitMask {
    static let gatorCategory:UInt32 = 0x1 << 0
    static let pipeCategory:UInt32 = 0x1 << 1
    static let groundCategory:UInt32 = 0x1 << 3
    
}

extension GameScene {
    //create gator sprite with its properties
    func createGator() -> SKSpriteNode{
        
        //create a sprite of the gator with height/width of 50. Make it start in centered position
        let gator = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("gator"))
        gator.size = CGSize(width: 50, height:50)
        gator.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        //have the gator sprite have a physics body of a circle with radius of half its width
        gator.physicsBody = SKPhysicsBody(circleOfRadius: gator.size.width / 2)
        gator.physicsBody?.linearDamping = 1.1
        gator.physicsBody?.restitution = 0
        
        //assign contact and collision bit masks to the pipe, ground and gator sprite
        gator.physicsBody?.categoryBitMask = CollisionBitMask.gatorCategory
        gator.physicsBody?.collisionBitMask = CollisionBitMask.pipeCategory | CollisionBitMask.groundCategory
        gator.physicsBody?.contactTestBitMask = CollisionBitMask.pipeCategory | CollisionBitMask.groundCategory
        
        //gator is affect by gravity
        gator.physicsBody?.affectedByGravity = false
        gator.physicsBody?.isDynamic = true
        
        return gator
        
    }
}
