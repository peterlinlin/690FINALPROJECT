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
    static let pillarCategory:UInt32 = 0x1 << 1
    static let groundCategory:UInt32 = 0x1 << 3
    
}

extension GameScene {
    func createGator() -> SKSpriteNode{
        let gator = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("gator"))
        gator.size = CGSize(width: 50, height:50)
        gator.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        gator.physicsBody = SKPhysicsBody(circleOfRadius: gator.size.width / 2)
        gator.physicsBody?.linearDamping = 1.1
        gator.physicsBody?.restitution = 0
        
        gator.physicsBody?.categoryBitMask = CollisionBitMask.gatorCategory
        gator.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        gator.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        
        gator.physicsBody?.affectedByGravity = false
        gator.physicsBody?.isDynamic = true
        
        return gator
        
    }
}
