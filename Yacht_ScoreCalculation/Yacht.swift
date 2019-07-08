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
    //cutレースの結果
    var cutResultList: [boat] = []
    

    //大会名
    var raceName:String!
    static let shared = raceInformation()
    private override init(){}
}

//class raceResult:NSObject {
//    //cutレースの時の順位の計算
//    func cutRaceResult() {
//        raceInformation.shared.cutResultList.sort{ $0.cutPoint > $1.cutPoint }
//        for i in 0..<raceInformation.shared.cutResultList.count {
//            raceInformation.shared.cutResultList[i].cutResult = i + 1
//        }
//    }
//    //cutレースがない時の順位の計算
//    func raceResult() {
//        raceInformation.shared.raceList.sort{$0.totalPoint > $1.totalPoint}
//        for i in 0..<raceInformation.shared.raceList.count {
//            raceInformation.shared.raceList[i].result = i + 1
//        }
//    }
//
//}

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
    var racePoint:[Int] = [0]
    //合計点数
    var totalPoint:Int!
    //cutの点数
    var cutPoint:Int!
    //一番悪い点数
    var badPoint:Int=0
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
//    //現在のレースの着順を更新する
//    func insertRacePoint() {
//        for i in 0..<afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1].count {
//            afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][i].currentRacePoint = i + 1
//        }
//        racePoint[raceInformation.shared.currentRaceNumber-1] = currentRacePoint
//    }
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
    var list = [[boat]]()
    static let shared = currentResult()
    private override init() {}
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
