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
    var raceCount:Int = 0
    //現在のレース
    var currentRaceNumber:Int = 1
    //cutレースがいつからか
    var cutRaceNumber:Int!
    //レースの結果
    var raceList: [boat] = []
    //cutレースの結果
    var cutResultList: [boat] = []

    //大会名
    var raceName:String!
    static let shared = raceInformation()
    private override init(){}
}

class raceResult:NSObject {
    //出でいないレースがあったらだめ
    //バブルソート
    //raceListの配列の順番を変える
    //cutレースの時の順位の計算
    func cutRaceResult() {
        
    }
    //cutレースがない時の順位の計算
    func raceResult() {
        
    }
}

class boat:NSObject {
    //艇番
    var boatNumber: String!
    //スキッパー
    var skipper: String!
    //クルー
    var crew: String!
    //現在のレースの順位
    var currentRacePoint:Int!
    //各レースのの順位
    var racePoint:[Int] = []
    //合計点数
    var totalPoint:Int!
    //cutの点数
    var cutPoint:Int!
    //一番悪い点数
    var badPoint:Int!
    //順位
    var result:Int!
    //cut順位
    var cutResult:Int!
    //
    var selected:Bool!
    
    //艇情報の追加
    func insert(first:String,second:String,thrid:String){
        self.boatNumber = first
        self.skipper = second
        self.crew = thrid
    }
    //現在のレースの着順を更新する
    func insertRacePoint() {
        for i in 0..<currentResult.shared.list.count {
            currentResult.shared.list[i].currentRacePoint = i + 1
        }
        racePoint[raceInformation.shared.currentRaceNumber] = currentRacePoint
    }
    //レースの合計点数を計算する
    func calculateRacePoint() {
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

class currentResult:NSObject {
    var list: [boat] = []
    static let shared = currentResult()
    private override init() {}
}
