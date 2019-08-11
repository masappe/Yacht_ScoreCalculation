//
//  ViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/29.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var raceFourButton: UIButton!
    @IBOutlet weak var raceSnipeButton: UIButton!
    @IBOutlet weak var decideFourButton: UIButton!
    @IBOutlet weak var decideSnipeButton: UIButton!
    @IBOutlet weak var univListButton: UIButton!
    @IBOutlet weak var addBoatButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    //realm
//    let realm = try! Realm()
    var AllUniv: Results<universal>!
    var Personal: Results<personal>!
    var Group: Results<group>!
    var RaceInformation: Results<raceInformation>!

    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        //realm
        AllUniv = realm.objects(universal.self)
        Personal = realm.objects(personal.self)
        Group = realm.objects(group.self)
        RaceInformation = realm.objects(raceInformation.self)

        switch RaceInformation[0].state {
        case "no":
            currentLabel.text = "レースに参加できます"
        case "470":
            currentLabel.text = "470レース中"
        case "snipe":
            currentLabel.text = "スナイプレース中"
        default:
            break
        }

    }
    
    @IBAction func addBoatButton(_ sender: Any) {
        if AllUniv.count != 0{
            performSegue(withIdentifier: "toDecide", sender: nil)
        } else {
            let alert = UIAlertController(title: "エラー", message: "大学を追加して下さい", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    //470出場艇決める
    @IBAction func selectFour(_ sender: Any) {
        performSegue(withIdentifier: "toSelect", sender: true)
    }
    //スナイプ出場艇決める
    @IBAction func selectSnipe(_ sender: Any) {
        performSegue(withIdentifier: "toSelect", sender: false)
    }
    //470レースへ
    @IBAction func raceFour(_ sender: Any) {
        switch RaceInformation[0].state {
        case "470":
            performSegue(withIdentifier: "toRace", sender: nil)
        case "snipe":
            let alert = UIAlertController(title: "STOP", message: "スナイプがレース中です", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        case "no":
            let alert = UIAlertController(title: "470のレースに参加する", message: "本当にこの船でよろしいですか？", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                let realm = try! Realm()
                try! realm.write{
                    self.RaceInformation[0].state = "470"
                    self.currentLabel.text = "470レース中"
                }
                //レースに必要な処理を記入する
                self.forRace470()
                //画面遷移
                self.performSegue(withIdentifier: "toRace", sender: nil)
            }
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
    //スナイプレースへ
    @IBAction func raceSnipe(_ sender: Any) {
        switch RaceInformation[0].state {
        case "470":
            let alert = UIAlertController(title: "STOP", message: "470がレース中です", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        case "snipe":
            performSegue(withIdentifier: "toRace", sender: nil)
        case "no":
            let alert = UIAlertController(title: "スナイプのレースに参加する", message: "本当にこの船でよろしいですか？", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                let realm = try! Realm()
                try! realm.write{
                    self.RaceInformation[0].state = "snipe"
                    self.currentLabel.text = "スナイプレース中"
                }
                //レースに必要な処理を記入する
                self.forRaceSnipe()
                //画面遷移
                self.performSegue(withIdentifier: "toRace", sender: nil)
            }
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        default:
            break
        }
    }
    //レース結果のリセット
    @IBAction func deleteRace(_ sender: Any) {
        let alert = UIAlertController(title: "終了", message: "レース結果を破棄してもよろしいですか", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            let realm = try! Realm()
            try! realm.write {
                self.RaceInformation[0].state = "no"
                self.currentLabel.text = "レースに参加できます"
            }
            //レース情報の破棄
            self.deleteAllRaceInformation()
        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    //遷移する前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelect" {
            let viewController = segue.destination as! SelectViewController
            viewController.boatType = sender as! Bool
        }
        if segue.identifier == "toDecide" {
            let decideViewController = segue.destination as! DecideViewController
            decideViewController.state = "add"
        }
    }
    
    //レースの全ての情報を破棄する
    func deleteAllRaceInformation(){
        let realm = try! Realm()

        try! realm.write {
            //団体の初期化
            for i in 0..<Group[0].raceList.count {
                Group[0].raceList[i].initialize()
            }
            Group[0].raceList.removeAll()
            //艇の初期化
            for i in 0..<Personal[0].raceList.count{
                Personal[0].raceList[i].initialize()
            }
            Personal[0].raceList.removeAll()
            //レース情報の初期化
            RaceInformation[0].initialize()
            //beforeGoalBoatの初期化
            //afterGoalBoatの初期化
            let BeforeGoalBoat = realm.objects(beforeGoalBoat.self)
            let AfterGoalBoat = realm.objects(afterGoalBoat.self)
            for i in 0..<BeforeGoalBoat.count{
                try! realm.write {
                    if BeforeGoalBoat[i].list.count >= 1 {
                        BeforeGoalBoat[i].list.removeAll()
                    }
                    if AfterGoalBoat[i].list.count >= 1{
                        AfterGoalBoat[i].list.removeAll()

                    }
                }
            }
            
//            beforeGoalBoat.shared.list.removeAll()
//            afterGoalBoat.shared.list.removeAll()
        }
    }
    //470のレースに参加する船の反映
    func forRace470(){
        let realm = try! Realm()
        try! realm.write{
            for i in 0..<AllUniv.count {
                for j in 0..<AllUniv[i].fourList.count {
                    if AllUniv[i].fourList[j].selected {
                        print(AllUniv[i].fourList[j])
                        //個人の追加
                        Personal[0].raceList.append(AllUniv[i].fourList[j])
                    }
                }
            }
            //1レースの目の情報の付与
            for i in 0..<Personal[0].raceList.count {
                Personal[0].raceList[i].cutSelect.append(false)
                Personal[0].raceList[i].racePoint.append(0)
            }

        }
        aboutUniv()
        settingRaceInf()

    }
    //スナイプのレースに参加する船の反映
    func forRaceSnipe(){
        let realm = try! Realm()
        try! realm.write{
            for i in 0..<AllUniv.count {
                for j in 0..<AllUniv[i].snipeList.count {
                    if AllUniv[i].snipeList[j].selected {
                        //個人の追加
                        Personal[0].raceList.append(AllUniv[i].snipeList[j])
                    }
                }
            }
            //1レースの目の情報の付与
            for i in 0..<Personal[0].raceList.count {
                Personal[0].raceList[i].cutSelect.append(false)
                Personal[0].raceList[i].racePoint.append(0)
            }
        }
        aboutUniv()
        settingRaceInf()

    }
    //レースを始めるための準備
    func settingRaceInf(){
        let realm = try! Realm()
        try! realm.write {
            //レース情報の初期化
            RaceInformation[0].boatNum = Personal[0].raceList.count
            RaceInformation[0].DNF = RaceInformation[0].boatNum + 1
            //beforeGaolBoat,afterGoalBoatの設定
            let after = afterGoalBoat()
            let before = beforeGoalBoat()
            realm.add(after)
            realm.add(before)
            let BeforeGoalBoat = realm.objects(beforeGoalBoat.self)
            for i in Personal[0].raceList{
                BeforeGoalBoat[0].list.append(i)
            }

        }
    }
    
    //どの大学が参加するかと大学に船情報の追加
    func aboutUniv(){
        //大学の追加と大学に各船の追加
        for i in 0..<Personal[0].raceList.count {
            if Group[0].raceList.count == 0 {
                let new = boats()
                new.univ = Personal[0].raceList[i].univ
                new.boat.append(Personal[0].raceList[i])
                let realm = try! Realm()

                try! realm.write {
                    Group[0].raceList.append(new)
                    Group[0].raceList[0].racePoint.append(0)
                }
            }else {
                var isInsert = false
                //既存の大学と一致しなかったら追加する
                hantei:for j in 0..<AllUniv.count{
                    if AllUniv[j].univ == Personal[0].raceList[i].univ {
                        //レースに出る団体に個人を追加する
                        for k in 0..<Group[0].raceList.count {
                            if Group[0].raceList[k].univ == Personal[0].raceList[i].univ{
                                let realm = try! Realm()

                                try! realm.write {
                                    Group[0].raceList[k].boat.append(Personal[0].raceList[i])
                                }
                                break hantei
                            }
                        }
                    }
                    //最後まで一致しなかったら
                    if j == AllUniv.count-1{
                        isInsert = true
                    }
                }
                if isInsert {
                    //一致しなかったら追加する
                    let new = boats()
                    new.univ = Personal[0].raceList[i].univ
                    new.boat.append(Personal[0].raceList[i])
                    let realm = try! Realm()

                    try! realm.write {
                        Group[0].raceList.append(new)
                    }
                }
                
            }
        }
        let realm = try! Realm()
        
        try! realm.write {
            //1レースの目の情報の付与
            for i in 0..<Group[0].raceList.count {
                Group[0].raceList[i].racePoint.append(0)
            }
        }

    }
    

    
}

