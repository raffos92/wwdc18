//
//  Box.swift
//  slingShot
//
//  Created by Raffaele Miraglia on 21/03/18.
//  Copyright © 2018 Raffaele Miraglia. All rights reserved.
//

import Foundation
import SpriteKit


public class Box: SKSpriteNode {
    
// we want count the number of the boxes in the scene , basically they represent enemy
 
  public static var numberOfBox = 0 {
        didSet {
            
            if numberOfBox < 0 {
                numberOfBox = 0
            }
            
        }
    }
    
    
  public  var isIndestructible: Bool = false
    
//  It's represent the integrity of box
  public  var integrity: Int = 2 {
        
        didSet {
            if integrity > 2 {
                integrity = 2
            }
            if integrity < 0 {
                removeFromParent()
                Box.numberOfBox -= 1
            }
            texture = SKTexture(imageNamed: "\(self.name!)_\(integrity)")
            
        }
    }
    

    
    public init(imageNamed: String) {
       
        super.init(texture: SKTexture(imageNamed: "\(imageNamed)_\(integrity)") , color: .clear, size: sizes.boxSize)
        
        self.name = imageNamed
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setPhysicsProperty(){
        

        
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        zPosition = zPositions.elasticBandright + 1
        physicsBody!.friction = 7
        

        physicsBody!.categoryBitMask = BodyType.box
        physicsBody!.contactTestBitMask = BodyType.box | BodyType.projectile | BodyType.ground
        physicsBody!.collisionBitMask = BodyType.box | BodyType.projectile | BodyType.ground
        
    }
    
}
