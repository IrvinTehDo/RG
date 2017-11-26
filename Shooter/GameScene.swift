//
//  GameScene.swift
//  Shooter
//
//  Created by student on 9/17/17.
//  Copyright © 2017 student. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory{
    static let None: UInt32 = 0
    static let All: UInt32 = UInt32.max
    static let Wall: UInt32 = 0b1
    static let Bullet: UInt32 = 0b100
    static let Player: UInt32 = 0b1000
}

class GameScene: SKScene, UIGestureRecognizerDelegate, SKPhysicsContactDelegate{
    
    let sceneManager:GameViewController
    
    var playableRect = CGRect.zero
    var totalSprites = 0
    
    let levelLabel = SKLabelNode(fontNamed: "Futura")
    let scoreLabel = SKLabelNode(fontNamed: "Futura")
    let otherLabel = SKLabelNode(fontNamed: "Futura")
    
    var lastUpdateTime: TimeInterval = 0
    var totalSessionTime: TimeInterval = 0
    var lastSpeedInc: TimeInterval = 0
    var lastSpawnTime: TimeInterval = 0
    var timeWhenPaused: TimeInterval = 0
    var totalTimePaused: TimeInterval = 0
    var timeUnpaused: TimeInterval = 0
    var dt: TimeInterval = 0
    var spritesMoving = false
    var cameFromPaused = false
    var timeFrozen = false
    
    var pLane = 3
    var pWidth = 100
    var pHeight = 100
    var pColor = SKColor.red
    var bulletCount = 0
    
    var spawnTime: Double = 7.7
    let spawnTimeDecRate: Double = 6/110 // Decrease Spawn rate
    
    var tapCount = 0 //3 taps and game is over!
    
    // MARK: - Initialization -
    init(size: CGSize, scaleMode: SKSceneScaleMode, sceneManager:GameViewController){
        self.sceneManager = sceneManager
        super.init(size: size)
        self.scaleMode = scaleMode
        
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func didMove(to view: SKView){
        setupUI()
        setupGestures(view: view)
        makeSprites(emptySpace: 1)
        makePlayer()
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        setupAudio()
        unpauseSprites()
    }
    //Implement collision
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if((firstBody.categoryBitMask & PhysicsCategory.Wall != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Bullet != 0)){
            if let wall = firstBody.node as? SquareSprite, let
                bullet = secondBody.node as? SquareSprite {
                bulletCollidesWithWall(bullet: bullet, wall: wall)
            }
        }
        
        if((firstBody.categoryBitMask & PhysicsCategory.Wall != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Player != 0)){
            if let wall = firstBody.node as? SquareSprite, let
                player = secondBody.node as? SquareSprite{
                playerCollidesWithWall(player: player, wall: wall)
            }
        }
        
    }
    
    deinit{
        // TODO: Clean up resources, timers, listeners, etc...
    }
    
    // MARK: - Helpers -
    private func setupUI(){
        playableRect = getPlayableRectPhonePortrait(size: size)
        backgroundColor = GameData.hud.backgroundColor
        makeLabel(text: "Time \(totalSessionTime)", x: 150, y: 100)
    }
    //Setup and Add Gestures to the current view.
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(fire))
        view.addGestureRecognizer(tap)

    }
    
    //Setup the background music of the game and add it to the scene.
    private func setupAudio(){
        let backgroundMusic = SKAudioNode(fileNamed: "background.wav")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        print("audio setup done")
    }
    
    // Create the UI labels that will appear on the bottom left of the screen to indicate time.
    func makeLabel(text: String, x: CGFloat, y:CGFloat){
        let label = SKLabelNode(fontNamed: GameData.font.mainFont)
        label.name = "time"
        label.text = text
        label.fontColor = UIColor.blue
        label.fontSize = 50
        label.position = CGPoint(x: x, y: y)
        label.zPosition = 4
        addChild(label)
    }
    
    // Update Score function that will look for the Child Node with the name of 'time' and update its value. Also checks if we've met the victory time condition.
    func updateScore(){
        enumerateChildNodes(withName: "time", using: {
            node, stop in
            let s = node as! SKLabelNode
            s.text = "Time: \(String(format: "%.1f", self.totalSessionTime))"
        })
        
        if(totalSessionTime > GameData.victoryTime){
            sceneManager.loadVictoryScene(timeResult: self.totalSessionTime)
        }
    }
    
    //If the scene detects a swipe, this method runs and determines what controll was triggered.
    @objc func swipeDetected(_ sender:UISwipeGestureRecognizer){
        //print("Something Happened in Swipe!")
        switch sender.direction
        {
            case UISwipeGestureRecognizerDirection.right:
                print("Swipe Right")
                if(pLane < 5){
                    pLane += 1
            }
            case UISwipeGestureRecognizerDirection.left:
                print("Swipe Left")
                if(pLane > 1){
                    pLane -= 1
            }
            case UISwipeGestureRecognizerDirection.up:
                print("Swipe Up")
                changeColor(color: SKColor.red)
                //self.isPaused = true
            
            case UISwipeGestureRecognizerDirection.down:
                print("Swipe Down")
                changeColor(color: SKColor.green)
            default:
            break
        }
    }

    //Creates the regular black walls that are not breakable then passes it on to determine if it makes an empty block at that location or not
    func makeSprites(emptySpace: Int){
        var s: SquareSprite
        for i in 0...4{
            if(i != emptySpace){
                s = SquareSprite(size: CGSize(width: 150, height: 100), lineWidth: 10, strokeColor: SKColor.black, fillColor: SKColor.white)
                s.name = "sqaure"
                s.position = CGPoint(x: Int(playableRect.maxX/6 * CGFloat(i+1)), y: Int(playableRect.maxY))
                s.fwd = CGPoint(x:0, y:-1)
                
                s.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 150, height: 100))
                s.physicsBody?.isDynamic = true
                s.physicsBody?.categoryBitMask = PhysicsCategory.Wall
                s.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Bullet
                s.physicsBody?.collisionBitMask = PhysicsCategory.None
                s.zPosition = 1
                addChild(s)
            }
        }
        
        makeSprites(loc: emptySpace)
    }
    
    //Chance to make block at specified location.
    func makeSprites(loc: Int){
        
        if(arc4random_uniform(101) > 50) // 50% chance to create a block that is colored
        {
            //Random Color
            let tempColor:SKColor!
            
            if(arc4random_uniform(2) == 1){
                tempColor = SKColor.red
            }
                
            else{
                tempColor = SKColor.green
            }
            
            // Create the block and assign it's properties.
            var s: SquareSprite
            
            s = SquareSprite(size: CGSize(width: 150, height: 100), lineWidth: 10, strokeColor: tempColor, fillColor: SKColor.white)
            s.color = tempColor
            s.name = "sqaure"
            s.position = CGPoint(x: Int(playableRect.maxX/6 * CGFloat(loc + 1)), y: Int(playableRect.maxY))
            s.fwd = CGPoint(x:0, y:-1)
            
            s.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 150, height: 100))
            s.physicsBody?.isDynamic = true
            s.physicsBody?.categoryBitMask = PhysicsCategory.Wall
            s.physicsBody?.contactTestBitMask = PhysicsCategory.Player | PhysicsCategory.Bullet
            s.physicsBody?.collisionBitMask = PhysicsCategory.None
            s.zPosition = 1
            
            addChild(s)
            //print("created colored")
        }
    }
    //Create the player and assigns its properties.
    func makePlayer(){
        var s: SquareSprite
        s = SquareSprite(size:CGSize(width: pWidth , height: pHeight), lineWidth: 10, strokeColor: pColor, fillColor:SKColor.white)
        s.name = "player"
        s.position = CGPoint(x: Int(playableRect.maxX/6 * CGFloat(pLane)), y: Int(playableRect.minY + 200))
        
        s.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pWidth, height: pHeight))
        s.physicsBody?.isDynamic = true
        s.physicsBody?.categoryBitMask = PhysicsCategory.Player
        s.physicsBody?.contactTestBitMask = PhysicsCategory.Wall
        s.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        addChild(s)
    }
    // Main key function of the game. Handles time and time events.
    func calculateDeltaTime(currentTime: TimeInterval)
    {
        //Calculate delta time if it's not coming from a paused state or if the time isn't frozen.
        if lastUpdateTime > 0  && !cameFromPaused && !timeFrozen{
            dt = currentTime - lastUpdateTime
        }
            
        // Calculates time since coming from unpaused subtracting time from time unpaused.
        else if lastUpdateTime > 0 && cameFromPaused{
            dt = NSDate.timeIntervalSinceReferenceDate - timeUnpaused
            cameFromPaused = false
            print(dt)
        }
        
        //If somehow, neither of the above conditions are true, there's probably no chance in the time since this last ran.
        else{
            dt = 0
        }
        
        lastUpdateTime = currentTime
        lastSpeedInc += dt
        lastSpawnTime += dt
        totalSessionTime += dt
        
        //print(totalSessionTime)
    }
    
    // Moves sprites as time progresses.
    func moveSprites(dt:CGFloat){
        
        if spritesMoving{
            enumerateChildNodes(withName: "sqaure", using:{
                node, stop in
                let s = node as! SquareSprite
                let halfHeight = s.frame.height/2
                
                s.update(dt:dt)
                
                // If sprite touches bottom of the screen, remove it.
                if s.position.y <= self.playableRect.minY + halfHeight{
                    s.removeFromParent()
                }
                
            })
            
            enumerateChildNodes(withName: "bullet", using:{
                node, stop in
                let s = node as! SquareSprite
                let halfHeight = s.frame.width/2
                
                s.update(dt:dt)
                
                // Emitter to attach to the bullet.
                if let e = self.childNode(withName: "trail"){
                    e.position.x = s.position.x
                    e.position.y = s.position.y
                }
                
                // Remove bullet and emitter if it touches the top of the screen and lower it's amount so our player can fire again.
                if s.position.y >= self.playableRect.maxY - halfHeight{
                    s.removeFromParent()
                    self.bulletCount -= 1
                    if let e = self.childNode(withName: "trail"){
                        e.removeFromParent()
                    }
                }
            })
        }
    }
    
    // Moves the player to the current lane the player is assigned or moved to
    func movePlayer(){
        enumerateChildNodes(withName: "player", using:{
            node, stop in
            let s = node as! SquareSprite
            s.position = CGPoint(x: Int(self.playableRect.maxX/6 * CGFloat(self.pLane)), y: Int(self.playableRect.minY + 200))
            s.zPosition = 2
        })
    }
    
    // Handles player's fire and makes a bullet 
    @objc func fire(){
        print("Touched Screen")
        //Fire Code Goes Here
        
        //return if the game hasn't started yet or if bulletCount is greater than 0
        if(bulletCount > 0 || !spritesMoving)
        {
            return
        }
        
        var s: SquareSprite
        s = SquareSprite(size:CGSize(width: 20 , height: 50), lineWidth: 10, strokeColor: pColor, fillColor:SKColor.white)
        s.color = pColor
        s.name = "bullet"
        s.position = CGPoint(x: Int(playableRect.maxX/6 * CGFloat(pLane)), y: Int(playableRect.minY + 200))
        s.delta = 1500
        s.fwd = CGPoint(x:0, y:1)
        
        s.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: 50))
        s.physicsBody?.isDynamic = true
        s.physicsBody?.categoryBitMask = PhysicsCategory.Bullet
        s.physicsBody?.contactTestBitMask = PhysicsCategory.Wall
        s.physicsBody?.collisionBitMask = PhysicsCategory.None
        s.physicsBody?.usesPreciseCollisionDetection = true
        s.zPosition = 0
        
        addChild(s)
        
        //Create the emitter that will be attached to the bullet
        let emitter = SKEmitterNode(fileNamed: "Effect")!
        emitter.name = "trail"
        emitter.zPosition = 0
        emitter.position = s.position
        addChild(emitter)
        
        //Play a soundclip when a bullet is fired.
        run(SKAction.playSoundFileNamed("fire.wav", waitForCompletion: false))
        
        //Increase bullet count so we can keep our number that can be fired to a maximum of 1
        bulletCount += 1
        
    }
    
    //Handles color change by assigning player to a color and updating its property to reflect so.
    func changeColor(color: SKColor){
        self.pColor = color
        
        enumerateChildNodes(withName: "player", using: {
            node, stop in
            let s = node as! SquareSprite
            s.strokeColor = self.pColor
        })
    }
    
    //Unpauses sprites and begins the game.
    func unpauseSprites(){
        let unpauseAction = SKAction.sequence([
            SKAction.wait(forDuration:2),
            SKAction.run({self.spritesMoving = true; self.totalSessionTime = 0})
            ])
        run(unpauseAction)
        
    }
    
    //Handles pause state
    func pauseGame(){
        print("yay game got paused")
        timeWhenPaused = NSDate.timeIntervalSinceReferenceDate
        
        print("Current Time When Paused: \(timeWhenPaused)")
    }
    
    //Handles unpause state
    func unpauseGame(){
        print("yay game got unpaused")
        timeUnpaused = NSDate.timeIntervalSinceReferenceDate
        //sets cameFromPaused to true to tell updateTime() to run a specific block of code to reflect the game state changing
        cameFromPaused = true
        
        print("Time When Resumed: \(timeUnpaused)")
        //print("Total Time Paused \(totalTimePaused)")
    }
    
    //Handles what happens if a bullet collides with a wall.
    func bulletCollidesWithWall(bullet: SquareSprite, wall: SquareSprite){
        print("collided")
        //Determines if the bullet color is equal to the wall color. If so, remove both. If not, remove the bullet only.
        if(bullet.color == wall.color)
        {
            run(SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false))
            wall.removeFromParent()
        }
        bullet.removeFromParent()
        
        //Remove the trail
        if let e = self.childNode(withName: "trail"){
            e.removeFromParent()
        }
        
        //Decrease bullet count so we can fire again
        bulletCount -= 1
    }
    
    //Did the player collide with a wall? 
    func playerCollidesWithWall(player: SquareSprite, wall: SquareSprite){
        print("player colildes and crashes")
        //run game over code
        
        //remove player
        player.removeFromParent()
        
        run(SKAction.sequence([
        		// Stop time from increasing because the game is over.
                SKAction.run({self.timeFrozen = true}),
                //Play death sound
                SKAction.playSoundFileNamed("die.wav", waitForCompletion: true),
                //Swap scenes.
                SKAction.run({self.sceneManager.loadGameOverScene(timeResult: self.totalSessionTime)})
            ]))
        //sceneManager.loadGameOverScene(timeResult: totalSessionTime)
    }

    // MARK: - Events -
    
    

    
    

    // MARK: - Game Loop -
    override func update(_ currentTime: TimeInterval){
		//Update Time and Update the Game based on the time updated.
        calculateDeltaTime(currentTime: currentTime)
        if(lastSpawnTime > spawnTime && spritesMoving){
            makeSprites(emptySpace: Int(arc4random_uniform(5)))
            lastSpawnTime = 0
        }
        // Increase spawn frequency based on the current time of the session.
        if(lastSpeedInc > 1.0 && spritesMoving && spawnTime > 1.7){
            spawnTime -= spawnTimeDecRate
            lastSpeedInc = 0
        }
        
        //Move the Sprites and Players.
        moveSprites(dt:CGFloat(dt))
        movePlayer()
        
        //Update score
        if(spritesMoving){
            updateScore()
        }

        
        //print(totalSessionTime)
    }

}
