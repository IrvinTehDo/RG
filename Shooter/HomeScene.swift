//
//  HomeScene.swift
//  Shooter
//
//  Created by student on 9/17/17.
//  Copyright © 2017 student. All rights reserved.
//

import SpriteKit
import GameplayKit

class HomeScene: SKScene, UIGestureRecognizerDelegate{
    // MARK: - ivars -
    let sceneManager:GameViewController
    let button: SKLabelNode = SKLabelNode(fontNamed: GameData.font.mainFont)
    
    
    // MARK: - Initialization -
    init(size: CGSize, scaleMode: SKSceneScaleMode, sceneManager: GameViewController){
        self.sceneManager = sceneManager
        super.init(size: size)
        self.scaleMode = scaleMode
    }
    
    required init(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func didMove(to view: SKView){ 
        setupUI()
        setupGestures(view: view)
    }
    
    // MARK: - Helper Methods -
    // Draw text on scene
    private func setupUI(){
        backgroundColor = GameData.scene.backgroundColor
        let label = SKLabelNode(fontNamed: GameData.font.mainFont)
        label.text = "R"
        label.fontSize = 200
        label.fontColor = SKColor.red
        label.position = CGPoint(x:size.width/2 - 65, y:size.height/2 + 400)
        label.zPosition = 1
        addChild(label)
        
        let label7 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label7.text = "G"
        label7.fontSize = 200
        label7.fontColor = SKColor.green
        label7.position = CGPoint(x:size.width/2 + 65, y:size.height/2 + 400)
        label7.zPosition = 1
        addChild(label7)
        
        let label2 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label2.text = "Survive for"
        label2.fontSize = 70
        label2.position = CGPoint(x:size.width/2, y:size.height/2 + 200)
        label2.zPosition = 1
        addChild(label2)
        
        let label3 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label3.text = "140 seconds!~"
        label3.fontSize = 70
        label3.position = CGPoint(x:size.width/2, y:size.height/2 + 100)
        label3.zPosition = 1
        addChild(label3)
        
        let label4 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label4.text = "Swipe up to play"
        label4.fontColor = UIColor.red
        label4.fontSize = 70
        label4.position = CGPoint(x:size.width/2, y:size.height/2 - 750)
        addChild(label4)
        
        let label5 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label5.text = "Swipe right for"
        label5.fontColor = UIColor.green
        label5.fontSize = 70
        label5.position = CGPoint(x:size.width/2, y:size.height/2 - 500)
        addChild(label5)
        
        let label6 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label6.text = "instructions"
        label6.fontColor = UIColor.green
        label6.fontSize = 70
        label6.position = CGPoint(x:size.width/2, y:size.height/2 - 600)
        addChild(label6)
    }
    
    //set up gesture events
    private func setupGestures(view: SKView){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeDetected))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeDetected))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        view.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeDetected))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        view.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDetected))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(swipeDown)
    }
    
    // MARK: - Events -
    
    // Depending on what gesture is triggered, it determines what scene to advance to.
    @objc func swipeDetected(_ sender:UISwipeGestureRecognizer){
        //print("Something Happened in Swipe!")
        switch sender.direction
        {
        case UISwipeGestureRecognizerDirection.right:
            print("Swipe Right")
            sceneManager.loadInstructionScene()

        case UISwipeGestureRecognizerDirection.left:
            print("Swipe Left")
   
        case UISwipeGestureRecognizerDirection.up:
            print("Swipe Up")
            sceneManager.loadGameScene()

        case UISwipeGestureRecognizerDirection.down:
            print("Swipe Down")
            
        default:
            break
        }
    }
}
