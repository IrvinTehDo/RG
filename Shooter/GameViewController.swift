//
//  GameViewController.swift
//  Shooter
//
//  Created by student on 9/17/17.
//  Copyright © 2017 student. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController{

    
    // MARK: - ivars -
    var gameScene: GameScene?
    var skView:SKView!
    let showDebugData = true
    let screenSize = CGSize(width: 1000, height: 1920) // IPhone 6+ 16:9 (1.77)
    let scaleMode = SKSceneScaleMode.aspectFill
    
    // MARK: - Initialization -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = self.view as! SKView
        loadHomeScene(isFromHomeMenu: false)
        
        // debug stuff
        skView.ignoresSiblingOrder = true
        skView.showsFPS = showDebugData
        skView.showsNodeCount = showDebugData
        
        NotificationCenter.default.addObserver(self, selector: #selector(appBecameInactive), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appBecameActive), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc func appBecameInactive(){
        if let view = gameScene{
            view.pauseGame()
            
        }
    }
    
    @objc func appBecameActive(){
        if let view = gameScene{
            view.unpauseGame()
        }
    }
    
    func loadHomeScene(isFromHomeMenu: Bool){
        let scene = HomeScene(size:screenSize, scaleMode:scaleMode, sceneManager: self)
        let reveal: SKTransition
        
        if(isFromHomeMenu){
            reveal = SKTransition.moveIn(with: SKTransitionDirection.right, duration: 1)
        }
        
        else{
            reveal = SKTransition.crossFade(withDuration: 1)
        }
        
        skView.presentScene(scene, transition: reveal)
    }
    
    func loadGameScene(){
        gameScene = GameScene(size:screenSize, scaleMode: scaleMode, sceneManager:self)
        
        // let reveal = SKTransition.flipHorizontal(withDuration: 1.0)
        let reveal = SKTransition.doorsOpenHorizontal(withDuration: 1)
        //let reveal = SkTransition.crossFade(withDuration: 1)
        skView.presentScene(gameScene!, transition: reveal)
        
    }
    
    func loadGameOverScene(timeResult:TimeInterval){
        gameScene = nil
        let scene = GameOverScene(size: screenSize, scaleMode: scaleMode, sceneManager: self, timeResult: timeResult)
        let reveal = SKTransition.doorsCloseVertical(withDuration: 1)
        skView.presentScene(scene, transition: reveal)
    }
    
    func loadVictoryScene(timeResult:TimeInterval){
        gameScene = nil
        let scene = VictoryScene(size: screenSize, scaleMode: scaleMode, sceneManager: self, timeResult: timeResult)
        let reveal = SKTransition.doorsOpenVertical(withDuration: 1)
        skView.presentScene(scene, transition:reveal)
    }
    
    func loadInstructionScene(){
        gameScene = nil
        let scene = InstructionScene(size:screenSize, scaleMode: scaleMode, sceneManager: self)
        let reveal = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 1)
        skView.presentScene(scene, transition: reveal)
        
    }
    
    // MARK: - Lifecycle -
    
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that arent in use
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    

}
