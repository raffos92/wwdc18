//
//  Projectile.swift
//  slingShot
//
//  Created by Raffaele Miraglia on 21/03/18.
//  Copyright © 2018 Raffaele Miraglia. All rights reserved.
//

import Foundation
import SpriteKit

//SKShapeNode
public class Projectile: SKSpriteNode {
    
    
    public init(imageNamed: String) {
        
        super.init(texture: SKTexture(imageNamed: imageNamed) , color: .clear, size: sizes.projectileSize)
        
        self.name = "box"
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func setupProjectile() {


       self.position = Settings.Metrics.projectileRestPosition
       self.zPosition = zPositions.elasticBandright + 1
        
       
        
    }
    
    public func setPhysicsProperty(){
        
        
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: Settings.Metrics.projectileRadius)
        
        
        self.physicsBody!.categoryBitMask = BodyType.projectile
        self.physicsBody!.contactTestBitMask =  BodyType.box | BodyType.ground
        self.physicsBody!.collisionBitMask = BodyType.projectile | BodyType.ground
        
/*    we'll set taffectedByGravity = true  after the throw, so that it remains in
      the resting position if it is not throw
 */
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.angularDamping = 4
        self.physicsBody!.linearDamping = 1
    }
    
}

