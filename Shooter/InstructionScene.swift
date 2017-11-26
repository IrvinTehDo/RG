//
//  InstructionScene.swift
//  RG
//
//  Created by student on 10/7/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation
import SpriteKit

class InstructionScene: SKScene{
    // MARK: - ivars -
    let sceneManager:GameViewController
    
    // MARKP: - init -
    init(size: CGSize, scaleMode:SKSceneScaleMode,sceneManager:GameViewController) {
        self.sceneManager = sceneManager
        super.init(size: size)
        self.scaleMode = scaleMode
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        setupUI()
        setupGestures(view: view)
    }
    
    // MAKR: - Helpers
    private func setupGestures(view: SKView){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeDetected))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeLeft)

    }
    // Draw text on screen
    private func setupUI(){
        backgroundColor = GameData.scene.backgroundColor
        
        let label = SKLabelNode(fontNamed: GameData.font.mainFont)
        label.text = "Instructions"
        label.fontSize = 100
        label.position = CGPoint(x:size.width/2, y:size.height - 200)
        addChild(label)
        
        let label3 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label3.text = "Swipe left to go"
        label3.fontColor = UIColor.red
        label3.fontSize = 70
        label3.position = CGPoint(x:size.width/2, y:size.height/2 - 700)
        addChild(label3)
        
        let label4 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label4.text = "to title"
        label4.fontColor = UIColor.red
        label4.fontSize = 70
        label4.position = CGPoint(x:size.width/2, y:size.height/2 - 800)
        addChild(label4)
        
        let label5 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label5.text = "Swipe left and right"
        label5.fontSize = 70
        label5.position = CGPoint(x:size.width/2, y:size.height - 400)
        addChild(label5)
        
        let label6 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label6.text = "to change lanes"
        label6.fontSize = 70
        label6.position = CGPoint(x:size.width/2, y:size.height - 500)
        addChild(label6)
        
        let label7 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label7.text = "Swipe up and down"
        label7.fontSize = 70
        label7.position = CGPoint(x:size.width/2, y:size.height - 700)
        addChild(label7)
        
        let label8 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label8.text = "to change colors"
        label8.fontSize = 70
        label8.position = CGPoint(x:size.width/2, y:size.height - 800)
        addChild(label8)
        
        let label9 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label9.text = "Tap to fire"
        label9.fontSize = 70
        label9.position = CGPoint(x:size.width/2, y:size.height - 1000)
        addChild(label9)
        
        let label10 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label10.text = "Crash into a wall"
        label10.fontSize = 70
        label10.position = CGPoint(x:size.width/2, y:size.height - 1200)
        addChild(label10)
        
        let label11 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label11.text = "and lose"
        label11.fontSize = 70
        label11.position = CGPoint(x:size.width/2, y:size.height - 1300)
        addChild(label11)
    }
    
    // MARK: - events -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //sceneManager.loadHomeScene(isFromHomeMenu: true)
        
    }
    
    @objc func swipeDetected(_ sender:UISwipeGestureRecognizer){
        //print("Something Happened in Swipe!")
        switch sender.direction
        {
        case UISwipeGestureRecognizerDirection.left:
            print("Swipe Left")
            //Bool to determine what type of transistion to animate with
            sceneManager.loadHomeScene(isFromHomeMenu: true)
        default:
            break
        }
    }
}
