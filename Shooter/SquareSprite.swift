//
//  SquareSprite.swift
//  Shooter
//
//  Created by student on 9/25/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation
import SpriteKit

class SquareSprite:SKShapeNode{
    // MARK: - ivars -
    var fwd:CGPoint = CGPoint(x:0.0, y:1.0) // North/UP
    var velocity: CGPoint = CGPoint.zero //speed with a direction
    var delta:CGFloat = 300.0 // Magnitude of Vector/Second
    var hit:Bool = false
    var color:SKColor?
    
    // Mark: - Initialization -
    init(size: CGSize, lineWidth: CGFloat, strokeColor:SKColor, fillColor: SKColor){
        super.init()
        let halfHeight = size.height/2.0
        let halfWidth = size.width/2.0
        let top = CGPoint(x:0, y:halfHeight)
        let right = CGPoint(x: halfWidth, y:0)
        let bottom = CGPoint(x:0, y:-halfHeight)
        let left = CGPoint(x:-halfWidth, y:0)
        
        let pathToDraw = CGMutablePath()
        pathToDraw.move(to: top + left)
        pathToDraw.addLine(to: right + top)
        pathToDraw.addLine(to: bottom + right)
        pathToDraw.addLine(to: left + bottom)
        pathToDraw.closeSubpath()
        path = pathToDraw
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
        self.fillColor = fillColor
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods -
    
    //Moves the sprite based on time and it's inherit values
    func update(dt:CGFloat){
        velocity = fwd * delta
        position = position + velocity * dt
        
    }
}
