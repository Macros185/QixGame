//
//  Enemy.swift
//  Qix Game
//
//  Created by Glen on 4/7/15.
//  Copyright (c) 2015 Melodic Bug. All rights reserved.
//

//import Foundation
import SpriteKit

class Enemy: SKSpriteNode {
    var sprite: SKSpriteNode
    
    override init(){
        self.sprite = SKSpriteNode(imageNamed: "triangle")
        super.init()
    }
    
    init(enemySprite: SKSpriteNode, name: String, size: CGSize, physicsBody: SKPhysicsBody, position: CGPoint, zPosition: CGFloat){
        self.sprite = enemySprite
        super.init()
        self.sprite.name = name
        self.sprite.size = size
        self.sprite.physicsBody = physicsBody
        self.sprite.position = position
        self.sprite.zPosition = zPosition
    }
    
    init(enemySpriteName: String, name: String, position: CGPoint, zPosition: CGFloat){
        self.sprite = SKSpriteNode(imageNamed: enemySpriteName)
        super.init()
        self.sprite.name = name
        //self.size = size
        //self.physicsBody = physicsBody
        self.sprite.position = position
        self.sprite.zPosition = zPosition
        self.sprite.texture = SKTexture(imageNamed: "triangle")
        self.sprite.size = CGSizeMake(self.sprite.texture!.size().width * 2.0, self.sprite.texture!.size().height * 2.0)
    }
    
    
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        self.sprite = SKSpriteNode()
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func initializePhysicsBody(texture: SKTexture, size: CGSize, isDynamic: Bool, isAffectedByGravity: Bool, linearDamping: CGFloat, friction: CGFloat, restitution: CGFloat, angularDamping: CGFloat, mass: CGFloat, collisionBitMask: UInt32, contactBitMask: UInt32, categoryBitMask: UInt32) -> SKPhysicsBody{
        var physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody.dynamic = isDynamic
        physicsBody.affectedByGravity = isAffectedByGravity
        physicsBody.linearDamping = linearDamping
        physicsBody.friction = friction
        physicsBody.restitution = restitution
        physicsBody.angularDamping = angularDamping
        physicsBody.mass = mass
        physicsBody.collisionBitMask = collisionBitMask
        physicsBody.contactTestBitMask = contactBitMask
        physicsBody.categoryBitMask = categoryBitMask
        physicsBody.usesPreciseCollisionDetection = true
        return physicsBody
    }
}