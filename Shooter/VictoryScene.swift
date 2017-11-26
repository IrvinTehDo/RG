//
//  VictoryScene.swift
//  RG
//
//  Created by student on 10/7/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation
import SpriteKit

class VictoryScene: SKScene{
    
    // MARK: - ivars -
    let sceneManager:GameViewController
    var timeResult:String
    
    // MARKP: - init -
    init(size: CGSize, scaleMode:SKSceneScaleMode,sceneManager:GameViewController,timeResult:TimeInterval) {
        self.sceneManager = sceneManager
        self.timeResult = String(format: "%.1f", timeResult)
        super.init(size: size)
        self.scaleMode = scaleMode
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupUI()
    }
    
    // MARK: - Helpers -
    
    //Displays text on screen and that we've won the game. Displays score
    private func setupUI(){
        backgroundColor = GameData.scene.backgroundColor
        
        let label = SKLabelNode(fontNamed: GameData.font.mainFont)
        label.text = "Congratulations"
        label.fontSize = 100
        label.position = CGPoint(x:size.width/2, y:size.height/2 + 300)
        addChild(label)
        
        let label2 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label2.text = "Time: \(self.timeResult)"
        label2.fontSize = 100
        label2.position = CGPoint(x: size.width/2, y:size.height/2)
        addChild(label2)
        
        let label3 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label3.text = "Tap to go to title"
        label3.fontColor = UIColor.red
        label3.fontSize = 70
        label3.position = CGPoint(x:size.width/2, y:size.height/2 - 500)
        addChild(label3)
    }
    
    // MARK: - events -
    
    //On tap, return to home screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneManager.loadHomeScene(isFromHomeMenu: false)
        
    }
}
