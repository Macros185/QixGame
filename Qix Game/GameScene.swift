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
    let enemy1 = SKSpriteNode(imageNamed: "triangle")
    let enemy2 = SKSpriteNode(imageNamed: "triangle")
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
        self.physicsBody?.friction = 0.0
        
        enemy1.name = "Triangle1"
        enemy1.size = CGSizeMake(enemy1.size.width * 2.0, enemy1.size.height * 2.0)
        enemy1.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "triangle"), size: enemy1.size)
        enemy1.physicsBody?.dynamic = true
        enemy1.physicsBody?.affectedByGravity = false
        enemy1.physicsBody?.linearDamping = 0
        enemy1.physicsBody?.friction = 0
        enemy1.physicsBody?.restitution = 1.0
        enemy1.physicsBody?.angularDamping = 0
        enemy1.physicsBody?.collisionBitMask = 1
        enemy1.physicsBody?.contactTestBitMask = 2
        enemy1.position = CGPoint(x: background.position.x + 300, y: background.position.y + 50)
        enemy1.zPosition = 9
        
        enemy2.name = "Triangle2"
        enemy2.size = CGSizeMake(enemy2.size.width * 2.0, enemy2.size.height * 2.0)
        enemy2.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "triangle"), size: enemy2.size)
        enemy2.physicsBody?.dynamic = true
        enemy2.physicsBody?.affectedByGravity = false
        enemy2.physicsBody?.linearDamping = 0
        enemy2.physicsBody?.friction = 0
        enemy2.physicsBody?.restitution = 1.0
        enemy2.physicsBody?.angularDamping = 0
        enemy2.physicsBody?.collisionBitMask = 1
        enemy2.physicsBody?.contactTestBitMask = 3
        enemy2.position = CGPoint(x: background.position.x + 300, y: background.position.y + 500)
        enemy2.zPosition = 9
        
        self.addChild(enemy2)
        self.addChild(enemy1)
        
        enemy1.physicsBody?.applyForce(CGVectorMake(0, 20))
        enemy2.physicsBody?.applyForce(CGVectorMake(0, -20))
        
        
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
                    player.physicsBody?.velocity.dy = 0.0
                    player.physicsBody?.velocity.dx = 0.0
                    player.physicsBody?.applyForce(CGVectorMake(70, 0))
                    deltaX = 20
                    deltaY = 0
                    currentDirection = "right"
                }
            
            case UISwipeGestureRecognizerDirection.Left:
                if player.position.x > 14 {
                    player.physicsBody?.velocity.dy = 0.0
                    player.physicsBody?.velocity.dx = 0.0
                    player.physicsBody?.applyForce(CGVectorMake(-70, 0))
                    deltaX = -20
                    deltaY = 0
                    currentDirection = "left"
                }
                
            case UISwipeGestureRecognizerDirection.Up:
                if player.texture!.size().height + player.position.y < self.frame.height + 7 {
                    player.physicsBody?.velocity.dx = 0.0
                    player.physicsBody?.velocity.dy = 0.0
                    player.physicsBody?.applyForce(CGVectorMake(0, 70))
                    deltaX = 0
                    deltaY = 20
                    currentDirection = "up"
                }
                
            case UISwipeGestureRecognizerDirection.Down:
                if player.position.y > 10 {
                    player.physicsBody?.velocity.dx = 0.0
                    player.physicsBody?.velocity.dy = 0.0
                    player.physicsBody?.applyForce(CGVectorMake(0, -70))
                    deltaX = 0
                    deltaY = -20
                    currentDirection = "down"
                }

            default:
                break
            }
            
            turnPosition = player.position
            lines.append(SKShapeNode())
        }
    }
    
    // MARK: SKScene Delegate Methods
    
    /*override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        var isNegativeX = arc4random_uniform(2)
        var isNegativeY = arc4random_uniform(2)
        var xForce = CGFloat(UInt(arc4random_uniform(100) + 1))
        var yForce = CGFloat(UInt(arc4random_uniform(100) + 1))
        
        if isNegativeX == 1 {
            xForce = -xForce
        }
        if isNegativeY == 1 {
            yForce = -yForce
        }
        
        enemy1.physicsBody?.applyImpulse(CGVectorMake(xForce, yForce))
    }*/
   
    override func update(currentTime: CFTimeInterval) {
        
        if player.texture!.size().width + player.position.x >= self.frame.width + 7 {
            player.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
            player.position.x = self.frame.width + 7 - player.texture!.size().width - 1
        }
        else if player.position.x <= 14 {
            player.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
            player.position.x = 15
        }
        
        
        if player.texture!.size().height + player.position.y >= self.frame.height + 7 {
            player.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
            player.position.y = self.frame.height + 7 - player.texture!.size().height - 1
        }
        else if player.position.y <= 10 {
            player.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
            player.position.y = 11
        }
        
        
        if enemy1.physicsBody?.angularVelocity < -5 {
            enemy1.physicsBody?.angularVelocity = -5
        }
        else if enemy1.physicsBody?.angularVelocity > 5 {
            enemy1.physicsBody?.angularVelocity = 5
        }
        
        
        if enemy2.physicsBody?.angularVelocity < -5 {
            enemy2.physicsBody?.angularVelocity = -5
        }
        else if enemy2.physicsBody?.angularVelocity > 5 {
            enemy2.physicsBody?.angularVelocity = 5
        }
        
        
        if enemy1.physicsBody?.velocity.dx < 0 {
            enemy1.physicsBody?.velocity.dx = -400
        }
        else{
            enemy1.physicsBody?.velocity.dx = 400
        }
        
        
        if enemy1.physicsBody?.velocity.dy < 0 {
            enemy1.physicsBody?.velocity.dy = -400
        }
        else{
            enemy1.physicsBody?.velocity.dy = 400
        }
        
        
        if enemy2.physicsBody?.velocity.dx < 0 {
            enemy2.physicsBody?.velocity.dx = -400
        }
        else{
            enemy2.physicsBody?.velocity.dx = 400
        }
        
        
        if enemy2.physicsBody?.velocity.dy < 0 {
            enemy2.physicsBody?.velocity.dy = -400
        }
        else{
            enemy2.physicsBody?.velocity.dy = 400
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
            nodeB.size = CGSizeMake(80.0, 70.0)
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