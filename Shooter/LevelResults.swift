//
//  LevelFinishScene.swift
//  Shooter
//
//  Created by student on 9/17/17.
//  Copyright © 2017 student. All rights reserved.
//

import Foundation
class LevelResults{
    let levelNum:Int
    let levelScore:Int
    let totalScore:Int
    let msg:String
    init(levelNum:Int, levelScore:Int, totalScore:Int,msg:String){
        self.levelNum = levelNum
        self.levelScore = levelScore
        self.totalScore = totalScore + levelScore
        self.msg = msg
    }
}
