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
    var turnPositions: [CGPoint] = []
    var contactQueue = [SKPhysicsContact]()
    var isProcessingCollision = false
    var lastDirection = "up"
    var currentDirection = "up"
    
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
        self.physicsBody?.collisionBitMask = Constants().borderCollisionBitMask
        self.physicsBody?.categoryBitMask = Constants().borderCategoryBitMask
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.friction = 100000000
        self.physicsBody?.restitution = 0.0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0
        
        var enemy1 = Enemy(enemySpriteName: "triangle", name: "Triangle1", position: CGPoint(x: background.position.x + 300, y: background.position.y + 50), zPosition: 9)
        enemy1.sprite.physicsBody = Enemy().initializePhysicsBody(enemy1.sprite.texture!, size: enemy1.sprite.size, isDynamic: true, isAffectedByGravity: false, linearDamping: 0, friction: 0, restitution: 1.0, angularDamping: 1.0, mass: 1, collisionBitMask: Constants().enemyCollisionBitMask, contactBitMask: 2, categoryBitMask: Constants().enemyCategoryBitMask)
        //Stops rotation
        enemy1.sprite.physicsBody?.allowsRotation = false
        
        var enemy2 = Enemy(enemySpriteName: "triangle", name: "Triangle2", position: CGPoint(x: background.position.x + 300, y: background.position.y + 500), zPosition: 9)
        enemy2.sprite.physicsBody = Enemy().initializePhysicsBody(enemy2.sprite.texture!, size: enemy2.sprite.size, isDynamic: true, isAffectedByGravity: false, linearDamping: 0, friction: 0, restitution: 1.0, angularDamping: 1.0, mass: 1, collisionBitMask: Constants().enemyCollisionBitMask, contactBitMask: 2, categoryBitMask: Constants().enemyCategoryBitMask)
        enemy2.sprite.physicsBody?.allowsRotation = false
        
        var enemy3 = Enemy(enemySpriteName: "triangle", name: "Triangle3", position: CGPoint(x: background.position.x + 300, y: background.position.y + 350), zPosition: 9)
        enemy3.sprite.physicsBody = Enemy().initializePhysicsBody(enemy3.sprite.texture!, size: enemy3.sprite.size, isDynamic: true, isAffectedByGravity: false, linearDamping: 0, friction: 0, restitution: 1.0, angularDamping: 1.0, mass: 1, collisionBitMask: Constants().enemyCollisionBitMask, contactBitMask: 2, categoryBitMask: Constants().enemyCategoryBitMask)
        enemy3.sprite.physicsBody?.allowsRotation = false
        
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
        player.physicsBody?.friction = 100000000
        player.physicsBody?.restitution = 0.0
        player.physicsBody?.angularDamping = 0
        player.physicsBody?.collisionBitMask = Constants().playerCollisionBitMask
        player.physicsBody?.contactTestBitMask = 0
        player.physicsBody?.categoryBitMask = Constants().playerCategoryBitMask
        player.position = CGPoint(x: background.position.x + 15, y: background.position.y + 15)
        player.zPosition = 9
        
        self.addChild(player)
        
        // Initialize turnPosition and lines variables to be used later.
        turnPositions.append(CGPoint(x: background.position.x + 15, y: background.position.y + 15))
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
                    player.physicsBody?.dynamic = true
                    player.physicsBody?.affectedByGravity = false
                    player.physicsBody?.friction = 100000000
                    player.physicsBody?.restitution = 0.0
                    player.physicsBody?.linearDamping = 0
                    player.physicsBody?.angularDamping = 0
                    player.physicsBody?.collisionBitMask = Constants().playerCollisionBitMask
                    player.physicsBody?.contactTestBitMask = 3
                    player.physicsBody?.allowsRotation = false
                    currentDirection = "right"
                }
            
            case UISwipeGestureRecognizerDirection.Left:
                if player.position.x > 14 {
                    player.texture = SKTexture(imageNamed: "triangle-left")
                    player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "triangle-left"), size: player.size)
                    player.physicsBody?.velocity.dy = 0.0
                    player.physicsBody?.velocity.dx = 0.0
                    player.physicsBody?.velocity.dx = -300.0
                    player.physicsBody?.dynamic = true
                    player.physicsBody?.affectedByGravity = false
                    player.physicsBody?.friction = 100000000
                    player.physicsBody?.restitution = 0.0
                    player.physicsBody?.linearDamping = 0
                    player.physicsBody?.angularDamping = 0
                    player.physicsBody?.collisionBitMask = Constants().playerCollisionBitMask
                    player.physicsBody?.contactTestBitMask = 3
                    player.physicsBody?.allowsRotation = false
                    currentDirection = "left"
                }
                
            case UISwipeGestureRecognizerDirection.Up:
                if player.texture!.size().height + player.position.y < self.frame.height + 7 {
                    player.texture = SKTexture(imageNamed: "triangle-up")
                    player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "triangle-up"), size: player.size)
                    player.physicsBody?.velocity.dx = 0.0
                    player.physicsBody?.velocity.dy = 0.0
                    player.physicsBody?.velocity.dy = 300.0
                    player.physicsBody?.dynamic = true
                    player.physicsBody?.affectedByGravity = false
                    player.physicsBody?.friction = 100000000
                    player.physicsBody?.restitution = 0.0
                    player.physicsBody?.linearDamping = 0
                    player.physicsBody?.angularDamping = 0
                    player.physicsBody?.collisionBitMask = Constants().playerCollisionBitMask
                    player.physicsBody?.contactTestBitMask = 3
                    player.physicsBody?.allowsRotation = false
                    currentDirection = "up"
                }
                
            case UISwipeGestureRecognizerDirection.Down:
                if player.position.y > 10 {
                    player.texture = SKTexture(imageNamed: "triangle-down")
                    player.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "triangle-down"), size: player.size)
                    player.physicsBody?.velocity.dx = 0.0
                    player.physicsBody?.velocity.dy = 0.0
                    player.physicsBody?.velocity.dy = -300.0
                    player.physicsBody?.dynamic = true
                    player.physicsBody?.affectedByGravity = false
                    player.physicsBody?.friction = 100000000
                    player.physicsBody?.restitution = 0.0
                    player.physicsBody?.linearDamping = 0
                    player.physicsBody?.angularDamping = 0
                    player.physicsBody?.collisionBitMask = Constants().playerCollisionBitMask
                    player.physicsBody?.contactTestBitMask = 3
                    player.physicsBody?.allowsRotation = false
                    currentDirection = "down"
                }

            default:
                break
            }
            
            turnPositions.append(player.position)
            lines.append(SKShapeNode())
        }
    }
    
    // MARK: SKScene Delegate Methods
   
    override func update(currentTime: CFTimeInterval) {
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
            lines[lines.count - 1].removeFromParent()
        }
        
        // Define line path.
        var pathToDraw = CGPathCreateMutable()
        CGPathMoveToPoint(pathToDraw, nil, player.position.x, player.position.y)
        CGPathAddLineToPoint(pathToDraw, nil, turnPositions[turnPositions.count - 1].x, turnPositions[turnPositions.count - 1].y)
        lines[lines.count - 1].path = pathToDraw
        lines[lines.count - 1].strokeColor = UIColor.redColor()
        
        // Draw line on scene.
        self.addChild(lines[lines.count - 1])
        
        if lastDirection != currentDirection {
            lines[lines.count - 2].removeFromParent()
            
            //var lastEndPoint = lines[lines.count - 2].frame
            var lastPathToDraw = CGPathCreateMutable()
            CGPathMoveToPoint(lastPathToDraw, nil, player.position.x, player.position.y)
            CGPathAddLineToPoint(lastPathToDraw, nil, turnPositions[turnPositions.count - 2].x, turnPositions[turnPositions.count - 2].y)
            lines[lines.count - 2].path = lastPathToDraw
            lines[lines.count - 2].strokeColor = UIColor.redColor()
            
            self.addChild(lines[lines.count - 2])
        }
        
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
            var nodeB = contact.bodyB.node as! SKSpriteNode
            if(nodeB.size.width != 80.0)
            {
                nodeB.size = CGSizeMake(80.0, 70.0)
                var mass = CGFloat(arc4random_uniform(9) + 1)
                mass = 1
                var collisionBitMask = nodeB.physicsBody?.collisionBitMask
                nodeB.physicsBody = Enemy().initializePhysicsBody(nodeB.texture!, size: nodeB.size, isDynamic: true, isAffectedByGravity: false, linearDamping: 0, friction: 0, restitution: 1.0, angularDamping: 1.0, mass: mass, collisionBitMask: collisionBitMask!, contactBitMask: 2, categoryBitMask: Constants().enemyCategoryBitMask)
                nodeB.physicsBody?.allowsRotation = false
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