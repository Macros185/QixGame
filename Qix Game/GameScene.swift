//
//  GameScene.swift
//  Qix Game
//
//  Created by Lauren Gallegos on 3/26/15.
//  Copyright (c) 2015 Melodic Bug. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // Static Variables
    var enemies = [Enemy]()
    let player = SKSpriteNode(imageNamed: "triangle")
    let background = SKSpriteNode(imageNamed:"background-vertical-2")
    
    // Dynamic Variables
    var lines: [SKShapeNode] = []
    var contactQueue = [SKPhysicsContact]()
    var turnPosition: CGPoint = CGPoint()
    var isProcessingCollision = false
    var deltaX: CGFloat = 0
    var deltaY: CGFloat = 0
    var lastDirection = ""
    var currentDirection = ""
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVectorMake(0, -9.8)
        
        background.anchorPoint = CGPointMake(0, 0)
        background.position = CGPointMake(0, 0)
        background.zPosition = 0
        
        self.addChild(background)
        
        let borderBody = SKPhysicsBody(edgeLoopFromRect: background.frame)
        self.name = "Border"
        self.physicsBody = borderBody
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.friction = 0.0
        
        var enemy1 = Enemy(enemySpriteName: "triangle", name: "Triangle1", position: CGPoint(x: background.position.x + 300, y: background.position.y + 50), zPosition: 9)
        enemy1.sprite.physicsBody = Enemy().initializePhysicsBody(enemy1.sprite.texture!, size: enemy1.sprite.size, isDynamic: true, isAffectedByGravity: false, linearDamping: 0, friction: 0, restitution: 1.0, angularDamping: 0, mass: 10, collisionBitMask: 1, contactBitMask: 2)
        
        var enemy2 = Enemy(enemySpriteName: "triangle", name: "Triangle2", position: CGPoint(x: background.position.x + 300, y: background.position.y + 500), zPosition: 9)
        enemy2.sprite.physicsBody = Enemy().initializePhysicsBody(enemy2.sprite.texture!, size: enemy2.sprite.size, isDynamic: true, isAffectedByGravity: false, linearDamping: 0, friction: 0, restitution: 1.0, angularDamping: 0, mass: 10, collisionBitMask: 1, contactBitMask: 2)
        
        var enemy3 = Enemy(enemySpriteName: "triangle", name: "Triangle3", position: CGPoint(x: background.position.x + 300, y: background.position.y + 350), zPosition: 9)
        enemy3.sprite.physicsBody = Enemy().initializePhysicsBody(enemy3.sprite.texture!, size: enemy3.sprite.size, isDynamic: true, isAffectedByGravity: false, linearDamping: 0, friction: 0, restitution: 1.0, angularDamping: 0, mass: 10, collisionBitMask: 1, contactBitMask: 2)
        
        enemies.insert(enemy1, atIndex:0)
        enemies.insert(enemy2, atIndex:0)
        enemies.insert(enemy3, atIndex:0)
        
        self.addChild(enemies[0].sprite)
        self.addChild(enemies[1].sprite)
        self.addChild(enemies[2].sprite)
        
        enemies[0].sprite.physicsBody?.applyForce(CGVectorMake(0, 20))
        enemies[1].sprite.physicsBody?.applyForce(CGVectorMake(0, -20))
        enemies[2].sprite.physicsBody?.applyForce(CGVectorMake(0, 5))
        
        player.name = "Player"
        player.size = CGSizeMake(player.size.width, player.size.height)
        player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "triangle"), size: player.size)
        player.physicsBody?.dynamic = true
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.linearDamping = 0
        player.physicsBody?.friction = 0
        player.physicsBody?.restitution = 0.0
        player.physicsBody?.angularDamping = 0
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = 3
        player.position = CGPoint(x: background.position.x + 15, y: background.position.y + 15)
        player.zPosition = 9
        
        self.addChild(player)
        
        turnPosition = CGPoint(x: background.position.x + 15, y: background.position.y + 15)
        lines.append(SKShapeNode())
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right;
        self.view?.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left;
        self.view?.addGestureRecognizer(swipeLeft)
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up;
        self.view?.addGestureRecognizer(swipeUp)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down;
        self.view?.addGestureRecognizer(swipeDown)
        
        var tap = UITapGestureRecognizer(target: self, action: "respondToGesture:")
        self.view?.addGestureRecognizer(tap)
    }
    
    func respondToGesture (gesture: UIGestureRecognizer) {
        player.physicsBody?.velocity.dx = 0.0
        player.physicsBody?.velocity.dy = 0.0
        deltaX = 0
        deltaY = 0
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction{
            case UISwipeGestureRecognizerDirection.Right:
                if player.texture!.size().width + player.position.x < self.frame.width + 7 {
                    player.texture = SKTexture(imageNamed: "triangle-right")
                    player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "triangle-right"), size: player.size)
                    player.physicsBody?.velocity.dy = 0.0
                    player.physicsBody?.velocity.dx = 0.0
                    player.physicsBody?.velocity.dx = 300.0
                    deltaX = 20
                    deltaY = 0
                    currentDirection = "right"
                    player.physicsBody?.dynamic = true
                    player.physicsBody?.affectedByGravity = false
                    player.physicsBody?.collisionBitMask = 0
                    player.physicsBody?.contactTestBitMask = 3
                }
            
            case UISwipeGestureRecognizerDirection.Left:
                if player.position.x > 14 {
                    player.texture = SKTexture(imageNamed: "triangle-left")
                    player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "triangle-left"), size: player.size)
                    player.physicsBody?.velocity.dy = 0.0
                    player.physicsBody?.velocity.dx = 0.0
                    player.physicsBody?.velocity.dx = -300.0
                    deltaX = -20
                    deltaY = 0
                    currentDirection = "left"
                    player.physicsBody?.dynamic = true
                    player.physicsBody?.affectedByGravity = false
                    player.physicsBody?.collisionBitMask = 0
                    player.physicsBody?.contactTestBitMask = 3
                }
                
            case UISwipeGestureRecognizerDirection.Up:
                if player.texture!.size().height + player.position.y < self.frame.height + 7 {
                    player.texture = SKTexture(imageNamed: "triangle-up")
                    player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "triangle-up"), size: player.size)
                    player.physicsBody?.velocity.dx = 0.0
                    player.physicsBody?.velocity.dy = 0.0
                    player.physicsBody?.velocity.dy = 300.0
                    deltaX = 0
                    deltaY = 20
                    currentDirection = "up"
                    player.physicsBody?.dynamic = true
                    player.physicsBody?.affectedByGravity = false
                    player.physicsBody?.collisionBitMask = 0
                    player.physicsBody?.contactTestBitMask = 3
                }
                
            case UISwipeGestureRecognizerDirection.Down:
                if player.position.y > 10 {
                    player.texture = SKTexture(imageNamed: "triangle-down")
                    player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "triangle-down"), size: player.size)
                    player.physicsBody?.velocity.dx = 0.0
                    player.physicsBody?.velocity.dy = 0.0
                    player.physicsBody?.velocity.dy = -300.0

                    deltaX = 0
                    deltaY = -20
                    currentDirection = "down"
                    player.physicsBody?.dynamic = true
                    player.physicsBody?.affectedByGravity = false
                    player.physicsBody?.collisionBitMask = 0
                    player.physicsBody?.contactTestBitMask = 3
                }

            default:
                break
            }
            
            turnPosition = player.position
            lines.append(SKShapeNode())
        }
    }
    
    // MARK: SKScene Delegate Methods
   
    override func update(currentTime: CFTimeInterval) {
        
//        if player.texture!.size().width + player.position.x >= self.frame.width + 7 {
//            player.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
//            player.position.x = self.frame.width + 7 - player.texture!.size().width - 1
//        }
//        else if player.position.x <= 14 {
//            player.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
//            player.position.x = 15
//        }
//        
//        if player.texture!.size().height + player.position.y >= self.frame.height + 7 {
//            player.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
//            player.position.y = self.frame.height + 7 - player.texture!.size().height - 1
//        }
//        else if player.position.y <= 10 {
//            player.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
//            player.position.y = 11
//        }
        
        // Do for each enemy.
        for enemy in enemies{
            // Constricts angular velocity within given range.
            if(enemy.sprite.physicsBody?.angularVelocity < -5){
                enemy.sprite.physicsBody?.angularVelocity = -5
            }
            else if(enemy.sprite.physicsBody?.angularVelocity > 5){
                enemy.sprite.physicsBody?.angularVelocity = 5
            }
            
            // Constricts x velocity within given range.
            if(enemy.sprite.physicsBody?.velocity.dx < 0){
                enemy.sprite.physicsBody?.velocity.dx = -300
            }
            else{
                enemy.sprite.physicsBody?.velocity.dx = 300
            }
            
            // Constricts y velocity within given range.
            if(enemy.sprite.physicsBody?.velocity.dy < 0){
                enemy.sprite.physicsBody?.velocity.dy = -300
            }
            else{
                enemy.sprite.physicsBody?.velocity.dy = 300
            }
        }
        
        processContactsForUpdate(currentTime)
        
        // Remove line from scene before drawing a new line if not new direction.
        if lastDirection == currentDirection {
            lines[lines.count-1].removeFromParent()
        }
        
        // Define line path.
        var pathToDraw = CGPathCreateMutable()
        CGPathMoveToPoint(pathToDraw, nil, player.position.x + deltaX, player.position.y + deltaY)
        CGPathAddLineToPoint(pathToDraw, nil, turnPosition.x, turnPosition.y)
        lines[lines.count-1].path = pathToDraw
        lines[lines.count-1].strokeColor = UIColor.redColor()
        
        // Draw line on scene.
        self.addChild(lines[lines.count-1])
        
        // Record current direction into lastDirection.
        lastDirection = currentDirection
    }
    
    // END MARK
    
    // MARK: SKPhysicsContactDelegate Methods
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody = contact.bodyA;
        var secondBody = contact.bodyB
        
        if !contactInQueue(contact) {
            contactQueue.append(contact)
        }
    }
    
    func contactInQueue(currentContact: SKPhysicsContact) -> Bool{
        for contact: SKPhysicsContact in contactQueue {
            if (currentContact.bodyA.node?.name == contact.bodyA.node?.name) && (currentContact.bodyB.node?.name == contact.bodyB.node?.name) {
                return true
            }
        }
        return false
    }
    
    func handleContact(contact: SKPhysicsContact){
        var name1 = contact.bodyA.node?.name
        var name2 = contact.bodyB.node?.name
        
        if (name1?.lowercaseString.rangeOfString("triangle") != nil) && (name2?.lowercaseString.rangeOfString("triangle") != nil) {
            var nodeB = contact.bodyB.node? as SKSpriteNode
            if(nodeB.size.width != 80.0)
            {
                nodeB.size = CGSizeMake(80.0, 70.0)
                var mass = CGFloat(arc4random_uniform(9) + 1)
                nodeB.physicsBody = Enemy().initializePhysicsBody(nodeB.texture!, size: nodeB.size, isDynamic: true, isAffectedByGravity: false, linearDamping: 0, friction: 0, restitution: 1.0, angularDamping: 0, mass: mass, collisionBitMask: 1, contactBitMask: 2)
            }
        }
    }
    
    func processContactsForUpdate(currentTime: NSTimeInterval){
        if !isProcessingCollision {
            isProcessingCollision = true
            
            for var i = contactQueue.count - 1; i >= 0 ; i--
            {
                handleContact(contactQueue[i])
                contactQueue.removeAtIndex(i)
            }
            isProcessingCollision = false
        }
    }
    
    // END MARK
}