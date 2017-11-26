//
//  GameData
//  Shooter
//
//  Created by jefferson on 9/15/16.
//  Copyright © 2016 tony. All rights reserved.
//

import SpriteKit

struct GameData{
    init(){
        fatalError("The GameData struct is a singleton")
    }
    static let maxLevel = 3
    static let victoryTime:Double = 140.0
    struct font{
        static let mainFont = "PingFangSC-Regular"
    }
    
    struct hud{
        static let backgroundColor = SKColor.white
        static let fontSize = CGFloat(64.0)
        static let fontColorWhite = SKColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
        static let marginV = CGFloat(12.0)
        static let marginH = CGFloat(12.0)
        static let shipMaxSpeedPerSecond = CGFloat(800.0)

    }
    
    struct image{
    }
    
    struct scene {
        static let backgroundColor = SKColor(red: 0.0, green: 0.5, blue: 0.90, alpha: 1.0)
    }
}

