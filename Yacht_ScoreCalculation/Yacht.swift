//
//  Yacht.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/29.
//  Copyright © 2019 masappe. All rights reserved.
//

import Foundation

class raceInformation:NSObject {
    //大会名
    var raceName = ""
    //大会開始
    var startRace = ""
    //大会終了
    var endRace = ""
    //レース数
    var raceCount:Int = 1
    //現在のレース
    var currentRaceNumber:Int = 1
    //cutレースがいつからか
    var cutRaceNumber = 0
    //船の数
    var boatNum = 0
    //レースの状態
    //470:470レース中，snipe:スナイプレース中,no:レースしていない
    var state = "no"
    //英語の種類一覧
    var DNF = 0
    var black: Int!
    
    static let shared = raceInformation()
    private override init(){}
    //レース情報の初期化
    func initialize() {
        raceCount = 1
        currentRaceNumber = 1
        boatNum = 0
        DNF = 1 
    }
    func update() {
        boatNum = personal.shared.raceList.count
        DNF = boatNum + 1
    }
}

//大学情報一覧
class alluniv:NSObject {
    var univList: [universal] = []
    static let shared = alluniv()
    private override init(){}
}
//大学情報，大学ごとの所有艇の情報も保持
class universal:NSObject {
    var univ: String!
    var fourList: [boat] = []
    var snipeList: [boat] = []
    
}
//レースに参加する大学一覧
class group:NSObject {
    var raceList: [boats] = []
    static let shared = group()
    private override init(){}
}
//レースに参加する大学情報
class boats:NSObject {
    //大学名
    var univ: String!
    //各レースの順位
    var racePoint:[Int] = [0]
    //どの艇が所属しているか
    var boat:[boat] = []
    //合計得点
    var totalPoint = 0
//    //cutの点数
//    var cutPoint = 0
//    //一番悪い点数
//    var badPoint = 0
    //順位
    var result:Int!
//    //cut順位
//    var cutResult:Int!
    //色付け
//    var color = false
    //clear:色なし，blue:青色，red:赤色
    var selectColor = "clear"
    
    //大学のレース情報の初期化
    func initialize(){
        racePoint.removeAll()
        racePoint = [0]
        boat.removeAll()
        totalPoint = 0
//        cutPoint = 0
//        badPoint = 0
    }
    //レースの合計点数を計算する
    func calculateRacePoint() {
        let sum = racePoint.reduce(0,+)
        totalPoint = sum

//        badPoint = 0
//        let sum = racePoint.reduce(0) {(num1:Int,num2:Int) -> Int in
//            if badPoint < num2 {
//                badPoint = num2
//            }
//            return num1 + num2
//        }
//        totalPoint = sum
//        cutPoint = sum - badPoint
    }

}
//レースに参加する船リスト
class personal:NSObject {
    var raceList: [boat] = []
    static let shared = personal()
    private override init(){}
}

//艇情報
class boat:NSObject {
    //艇番
    var boatNumber: Int!
    //スキッパー
    var skipper: String!
    //クルー
    var crew: String!
    //大学名
    var univ:String!
    //艇種
    //True:470,false:snipe
    var boatType:Bool!
    //各レースのの順位
    var racePoint:[Int] = [0]
    //カットされるかされないか
    var cutSelect:[Bool] = [false]
    //合計点数
    var totalPoint:Int = 0
    //cutの点数
    var cutPoint:Int = 0
    //一番悪い点数
    var badPoint:Int=0
    //順位
    var result = 1
    //cut順位
    var cutResult = 1
    //レースに出るかの判断基準，色の選択の判断基準
    var selected:Bool!
    //色付け
//    var color = false
    //clear:色なし，blue:青色，red:赤色
    var selectColor = "clear"

    
    //艇のレース情報の初期化
    func initialize(){
        racePoint.removeAll()
        racePoint = [0]
        totalPoint = 0
        cutPoint = 0
        badPoint = 0
        selected = false
    }

    //艇情報の追加
    func insert(first:Int,second:String,thrid:String,fourth:String,fifth:String){
        self.boatNumber = first
        self.skipper = second
        self.crew = thrid
        self.univ = fourth
        if fifth == "470" {
            self.boatType = true
        } else {
            self.boatType = false
        }
    }
    //レースの合計点数を計算する
    func calculateRacePoint() {
        badPoint = 0
        var temp1:[Int] = []
        for i in 0..<cutSelect.count {
            if !cutSelect[i] {
                temp1.append(i)
            }
        }
        var temp:[Int] = []
        for j in 0..<temp1.count{
            temp.append(racePoint[temp1[j]])
        }
        if let max = temp.max() {
            badPoint = max
        }
//        var temp = racePoint
//        //cutPointの計算
//        for _ in 0..<cutSelect.count {
//            let maxIndex = temp.firstIndex{ $0 == temp.max() }
//            if !cutSelect[maxIndex!] {
//                badPoint = temp[maxIndex!]
//                break
//            }
//            temp.remove(at: maxIndex!)
//        }
        
        let sum = racePoint.reduce(0,+)
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
