//
//  Setting.swift
//  slingShot
//
//  Created by Raffaele Miraglia on 21/03/18.
//  Copyright © 2018 Raffaele Miraglia. All rights reserved.
//

import Foundation
import SpriteKit

public struct Settings {
    public static var gameView: SKView = SKView()
    
    public struct Metrics {
        
        
        public static let projectileRadius = CGFloat(10)

        public static let projectileRestPosition = CGPoint(x: gameView.bounds.minX + 100, y: gameView.bounds.minY + 70.7)
       
        public static let projectileTouchThreshold = CGFloat(10)
        public static let projectileSnapLimit = CGFloat(10)
        
        public static let rLimit = CGFloat(65)
       
    }
   public  struct Game {
        public static var gravity = defaultProperty.gravity
       public static var slingSpringiness  = defaultProperty.slingSpringiness  //forcemultiplier  or costante elastica
        public static var projectileSpringiness = defaultProperty.projectileSpringiness
       
        /** Weight in Kg*/
        public static var projectileMass  = defaultProperty.projectileMass
        
        /** Weight in Kg*/
        public static var boxMass = defaultProperty.boxMass
    }
    
  public  struct defaultProperty {
       public static let gravity = CGFloat(-9.8)
       public  static let slingSpringiness  = CGFloat(1.5)  //forcemultiplier  or costante elastica
      
       public  static let projectileSpringiness = CGFloat(0.5)
        /** Weight in Kg*/
       public  static let projectileMass  = CGFloat(0.06) //0.06
        
        /** Weight in Kg*/
       public static let boxMass = CGFloat(1)
        
    
    }
}


public struct sizes {
    public  static let boxSize = CGSize(width: 35, height: 30)
    public  static let projectileSize = CGSize(width: 23, height: 23)
}


public enum BodyType {

   public  static let projectile: UInt32 = 0x1 << 1    // 2
   public  static let ground: UInt32 = 0x1 << 2    // 4
   public  static let box: UInt32 = 0x1 << 3     // 8


}

public enum costants {
   public static let maxcountdow: TimeInterval = 40
    
   public static let mincountdow: TimeInterval = 25
}

public enum zPositions {
    
    
    public static let leftSling:CGFloat  = 2
    public static let elasticBandleft:CGFloat  = 1
    public static let projectile:CGFloat  = 3
    public static let elasticBandright:CGFloat  = 4
    public static let rightSling:CGFloat = 5
    
    
}

