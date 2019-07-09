//
//  Yacht.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/29.
//  Copyright © 2019 masappe. All rights reserved.
//

import Foundation

class raceInformation:NSObject {
    //レース数
    var raceCount:Int = 1
    //現在のレース
    var currentRaceNumber:Int = 1
    //cutレースがいつからか
    var cutRaceNumber:Int! = 3
    //レースの結果
    var raceList: [boat] = []
    //英語の種類一覧
    var DNF = 1000
    var black: Int!
    

    //大会名
    var raceName:String!
    static let shared = raceInformation()
    private override init(){}
    
    func initialize() {
        raceList.removeAll()
        raceCount = 1
        currentRaceNumber = 1
    }
}


class boat:NSObject {
    //艇番
    var boatNumber: Int!
    //スキッパー
    var skipper: String!
    //クルー
    var crew: String!
    //現在のレースの順位
//    var currentRacePoint:Int!
    //各レースのの順位
    var racePoint:[Int] = [0]
    //合計点数
    var totalPoint:Int = 1000
    //cutの点数
    var cutPoint:Int = 1000
    //一番悪い点数
    var badPoint:Int=0
    //順位
    var result:Int!
    //cut順位
    var cutResult:Int!
    //レースに出るかの判断基準，色の選択の判断基準
    var selected:Bool!
    
    //艇情報の追加
    func insert(first:Int,second:String,thrid:String){
        self.boatNumber = first
        self.skipper = second
        self.crew = thrid
    }
    //レースの合計点数を計算する
    func calculateRacePoint() {
        badPoint = 0
        let sum = racePoint.reduce(0) {(num1:Int,num2:Int) -> Int in
            if badPoint < num2 {
                badPoint = num2
            }
            return num1 + num2
        }
        totalPoint = sum
        cutPoint = sum - badPoint
        
    }
    
    
}

class fourSevenZero:NSObject {
    var list: [boat] = []
    static let shared = fourSevenZero()
    private override init(){}
}

class snipe:NSObject {
    var list: [boat] = []
    static let shared = snipe()
    private override init(){}
    
}


class beforeGoalBoat:NSObject {
    var list = [[boat]]()
    static let shared = beforeGoalBoat()
    private override init() {}

}
class afterGoalBoat:NSObject {
    var list = [[boat]]()
    static let shared = afterGoalBoat()
    private override init() {}

}
