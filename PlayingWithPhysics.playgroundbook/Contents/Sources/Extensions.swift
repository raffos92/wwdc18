//
//  Extensions.swift
//  slingShot
//
//  Created by Raffaele Miraglia on 22/03/18.
//  Copyright © 2018 Raffaele Miraglia. All rights reserved.
//

import Foundation

import UIKit

 extension CGFloat {
    public func clamped(v1: CGFloat, _ v2: CGFloat) -> CGFloat {
        let min = v1 < v2 ? v1 : v2
        let max = v1 > v2 ? v1 : v2
        return self < min ? min : (self > max ? max : self)
    }
}

extension CGPoint {
    
    public func distanceFromPoint(point: CGPoint) -> CGFloat{
        let xDist = (x - point.x)
        let yDist = (y - point.y)
        return sqrt((xDist * xDist) + (yDist * yDist))
    }
    
    public func addPoint(point: CGPoint) -> CGPoint{
        return CGPoint(x: self.x+point.x, y: self.y+point.y)
    }
    
    public func subtract(point: CGPoint) -> CGPoint{
        return CGPoint(x: self.x-point.x, y: self.y-point.y)
    }
}

