//
//  Yacht.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/29.
//  Copyright © 2019 masappe. All rights reserved.
//

import Foundation
import RealmSwift


class raceInformation:Object {
    
    //大会名
    @objc dynamic var raceName = ""
    //大会開始
    @objc dynamic var startRace = ""
    //大会終了
    @objc dynamic var endRace = ""
    //レース数
    @objc dynamic var raceCount:Int = 1
    //現在のレース
    @objc dynamic var currentRaceNumber:Int = 1
    //cutレースがいつからか
    @objc dynamic var cutRaceNumber = 0
    //船の数
    @objc dynamic var boatNum = 0
    //レースの状態
    //470:470レース中，snipe:スナイプレース中,no:レースしていない
    @objc dynamic var state = "no"
    //レースを更新したかどうか
    @objc dynamic var doneUpdateCount = 0

    //英語の種類一覧
    @objc dynamic var DNF = 0
    
    //レース情報の初期化
    func initialize() {
        raceName = ""
        startRace = ""
        endRace = ""
        raceCount = 1
        currentRaceNumber = 1
        cutRaceNumber = 0
        boatNum = 0
        DNF = 1
        doneUpdateCount = 0
    }
}

//大学情報，大学ごとの所有艇の情報も保持
class universal:Object {
    @objc dynamic var univ: String!
    var fourList = List<boat>()
    var snipeList = List<boat>()
    
}
//レースに参加する大学一覧
class group:Object {
    var raceList = List<boats>()
}
//レースに参加する大学情報
class boats:Object {
    //大学名
    @objc dynamic var univ: String!
    //各レースの順位
    var racePoint = List<Int>()
    //どの艇が所属しているか
    var boat = List<boat>()
    //合計得点
    @objc dynamic var totalPoint = 0
    //順位
    @objc dynamic var result = 0
    //clear:色なし，blue:青色，red:赤色
    @objc dynamic var selectColor = "clear"
    
    //大学のレース情報の初期化
    func initialize(){
        racePoint.removeAll()
        boat.removeAll()
        totalPoint = 0
        result = 0
        selectColor = "clear"
    }
    //レースの合計点数を計算する
    func calculateRacePoint() {
        let sum = racePoint.reduce(0,+)
        totalPoint = sum
    }

}
//レースに参加する船リスト
class personal:Object {
    var raceList = List<boat>()
}

//艇情報
class boat:Object {
    //艇番
    @objc dynamic var boatNumber = 0
    //スキッパー
    @objc dynamic var skipper = ""
    //クルー
    @objc dynamic var crew = ""
    //大学名
    @objc dynamic var univ:String!
    //艇種
    //True:470,false:snipe
    @objc dynamic var boatType = true
    //各レースのの順位
    //0を入れないといけない
    var racePoint = List<Int>()
    //カットされるかされないか
    //falseを入れないといけない
    var cutSelect = List<Bool>()
    //合計点数
    @objc dynamic var totalPoint:Int = 0
    //cutの点数
    @objc dynamic var cutPoint:Int = 0
    //一番悪い点数
    @objc dynamic var badPoint:Int = 0
    //順位
    @objc dynamic var result = 1
    //cut順位
    @objc dynamic var cutResult = 1
    //レースに出るかの判断基準，色の選択の判断基準
    @objc dynamic var selected = false
    //色付け
    //clear:色なし，blue:青色，red:赤色
    @objc dynamic var selectColor = "clear"

    
    //艇のレース情報の初期化
    func initialize(){
        racePoint.removeAll()
        cutSelect.removeAll()
        totalPoint = 0
        cutPoint = 0
        badPoint = 0
        selected = false
        selectColor = "clear"
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
        let sum = racePoint.reduce(0,+)
        totalPoint = sum
        cutPoint = sum - badPoint
    }
    
}

class beforeGoalBoat:Object {
    var list = List<boat>()
}
class afterGoalBoat:Object {
    var list = List<boat>()
}
