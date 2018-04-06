//
//  SlingShot.swift
//  slingShot
//
//  Created by Raffaele Miraglia on 23/03/18.
//  Copyright © 2018 Raffaele Miraglia. All rights reserved.
//

import Foundation
import SpriteKit

public class SlingShot:SKNode{
    
    
    
/*  To give the user the impression that the ball is moving between the slingshot’s brances while the user is dragging, we need to add the children with the correct order. Which is : leftSlingSprite -> leftSling -> projectile -> rightSling -> rightSlingSprite.
     
*/
    private var leftSlingSprite: SKSpriteNode
    private var leftSlingPosition: CGPoint!
    private var leftSling: SKShapeNode!
    
    private var rightSlingSprite: SKSpriteNode
    private var rightSlingPosition: CGPoint!
    private var rightSling: SKShapeNode!
    
/*  leftSling represent the elastic band between the projectile and left brance of slingshot
    righSling represent the elastic band between the projectile and right brance of slingshot
*/
    public var slingColor = SKColor.green

    public var slingSpringiness = Settings.defaultProperty.slingSpringiness
  
   
    
    public override init() {

 
        
        leftSlingSprite = SKSpriteNode(imageNamed: "slingshot_1")
        
        leftSlingSprite.position = CGPoint(x: Settings.gameView.bounds.minX + 100, y: Settings.gameView.bounds.minY + leftSlingSprite.size.height / 8 )
        
        
        leftSlingSprite.zPosition = zPositions.leftSling
        leftSlingSprite.size.width = Settings.gameView.bounds.width / 12
        leftSlingSprite.size.height = Settings.gameView.bounds.height / 6
        
        
        
        rightSlingSprite = SKSpriteNode(imageNamed: "slingshot_2")
        
        rightSlingSprite.position = CGPoint(x: Settings.gameView.bounds.minX + 100, y: Settings.gameView.bounds.minY + rightSlingSprite.size.height / 8 )
        
        rightSlingSprite.zPosition = zPositions.rightSling
        rightSlingSprite.size.width = Settings.gameView.bounds.width / 12
        rightSlingSprite.size.height = Settings.gameView.bounds.height / 6
        
        
     
        
        
       super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    public func setupSling(){
       
        
        slingSpringiness = Settings.Game.slingSpringiness
        
        self.addChild(rightSlingSprite)
        self.addChild(leftSlingSprite)
        
       
        let slingshot1 = leftSlingSprite
        let slingshot2 = rightSlingSprite
        
        
        
        
        self.leftSlingPosition = CGPoint(x: slingshot1.position.x + slingshot1.size.width/2 - 3.5  , y: slingshot1.position.y + slingshot1.size.height/2 - 10)
        
//      We use CGMutablePath to update dynamically the length and position of the elastic band
       
        var path = CGMutablePath()
        path.move(to: CGPoint.zero)
  
        
        path.addLine(to: Settings.Metrics.projectileRestPosition.subtract(point: leftSlingPosition) )
        
        
        path.closeSubpath()
        
        self.leftSling = SKShapeNode(path: path)
        self.leftSling.lineWidth = 8
        self.leftSling.zPosition = zPositions.elasticBandleft
        self.leftSling.fillColor = slingColor
        self.leftSling.strokeColor = slingColor
        self.addChild(self.leftSling)
        
        
        leftSling.position = self.leftSlingPosition
        
        self.rightSlingPosition = CGPoint(x: slingshot2.position.x - slingshot2.size.width/2 + 2.5 , y: slingshot2.position.y + slingshot2.size.height/2 - 10)
        path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: Settings.Metrics.projectileRestPosition.subtract(point: rightSlingPosition))
        path.closeSubpath()
        
        self.rightSling = SKShapeNode(path: path)
        self.rightSling.lineWidth = 8
        self.rightSling.zPosition = zPositions.elasticBandright
        self.rightSling.fillColor = slingColor
        self.rightSling.strokeColor = slingColor
        self.addChild(self.rightSling)
        
        self.rightSling.position = self.rightSlingPosition
        
        
    }
    
    public func update(projectilePosition : CGPoint)  {
    //Updating sling position
    var path = CGMutablePath()
    path.move(to: CGPoint.zero)
    path.addLine(to: projectilePosition.subtract(point: leftSlingPosition))
    path.closeSubpath()
    self.leftSling.path = path
    
    path = CGMutablePath()
    path.move(to: CGPoint.zero)
    path.addLine(to: projectilePosition.subtract(point: rightSlingPosition))
    path.closeSubpath()
    self.rightSling.path = path
    
    }
    
    public func restSling() {
        var path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: Settings.Metrics.projectileRestPosition.subtract(point: leftSlingPosition))
        path.closeSubpath()
        self.leftSling.path = path
        
        path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: Settings.Metrics.projectileRestPosition.subtract(point: rightSlingPosition))
        path.closeSubpath()
        self.rightSling.path = path
    }
    
    
   
    
    
    
}
