//
//  ViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/29.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //テストデータで使用中
        let meikou = universal()
        meikou.univ = "名工"
        let mie = universal()
        mie.univ = "三重"
        let meizyou = universal()
        meizyou.univ = "名城"
        alluniv.shared.univList.append(meikou)
        alluniv.shared.univList.append(mie)
        alluniv.shared.univList.append(meizyou)

        for i in 0...2 {
            let registerBoat = boat()
            registerBoat.insert(first: Int(i), second: "", thrid: "",fourth: "名工",fifth: "スナイプ")
            registerBoat.selected = false
            snipe.shared.list.append(registerBoat)
            for j in 0..<alluniv.shared.univList.count {
                if registerBoat.univ == alluniv.shared.univList[j].univ{
                    alluniv.shared.univList[j].snipeList.append(registerBoat)
                }
            }
        }
        for i in 3...6 {
            let registerBoat = boat()
            registerBoat.insert(first: Int(i), second: "", thrid: "",fourth: "三重",fifth: "スナイプ")
            registerBoat.selected = false
            snipe.shared.list.append(registerBoat)
            for j in 0..<alluniv.shared.univList.count {
                if registerBoat.univ == alluniv.shared.univList[j].univ{
                    alluniv.shared.univList[j].snipeList.append(registerBoat)
                }
            }
        }
        for i in 7...9 {
            let registerBoat = boat()
            registerBoat.insert(first: Int(i), second: "", thrid: "",fourth: "名城",fifth: "スナイプ")
            registerBoat.selected = false
            snipe.shared.list.append(registerBoat)
            for j in 0..<alluniv.shared.univList.count {
                if registerBoat.univ == alluniv.shared.univList[j].univ{
                    alluniv.shared.univList[j].snipeList.append(registerBoat)
                }
            }
        }

    }
    
    @IBAction func selectFour(_ sender: Any) {
        performSegue(withIdentifier: "toSelect", sender: true)
    }
    
    @IBAction func selectSnipe(_ sender: Any) {
        performSegue(withIdentifier: "toSelect", sender: false)
    }
    //470レースへ
    @IBAction func raceFour(_ sender: Any) {
        switch raceInformation.shared.state {
        case "470":
            performSegue(withIdentifier: "toRace", sender: nil)
        case "snipe":
            let alert = UIAlertController(title: "STOP", message: "スナイプがレース中です", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        case "no":
            let alert = UIAlertController(title: "470のレースに参加する", message: "本当にこの船でよろしいですか？", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default) { (action) in
                raceInformation.shared.state = "470"
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
        switch raceInformation.shared.state {
        case "470":
            let alert = UIAlertController(title: "STOP", message: "470がレース中です", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        case "snipe":
            performSegue(withIdentifier: "toRace", sender: nil)
        case "no":
            let alert = UIAlertController(title: "スナイプのレースに参加する", message: "本当にこの船でよろしいですか？", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default) { (action) in
                raceInformation.shared.state = "snipe"
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
    
    @IBAction func deleteRace(_ sender: Any) {
        let alert = UIAlertController(title: "終了", message: "レース結果を破棄してもよろしいですか", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            raceInformation.shared.state = "no"
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
    }
    
    //レースの全ての情報を破棄する
    func deleteAllRaceInformation(){
        //団体の初期化
        for i in 0..<group.shared.raceList.count {
            group.shared.raceList[i].initialize()
        }
        group.shared.raceList.removeAll()
        //艇の初期化
        for i in 0..<personal.shared.raceList.count{
            personal.shared.raceList[i].initialize()
        }
        personal.shared.raceList.removeAll()
        //レース情報の初期化
        raceInformation.shared.initialize()
        
    }
    //470のレースに参加する船の反映
    func forRace470(){
        for i in 0..<alluniv.shared.univList.count {
            for j in 0..<alluniv.shared.univList[i].fourList.count {
                if alluniv.shared.univList[i].fourList[j].selected {
                    //個人の追加
                    personal.shared.raceList.append(alluniv.shared.univList[i].fourList[j])
                }
            }
        }
        aboutUniv()
        raceInformation.shared.update()
    }
    //スナイプのレースに参加する船の反映
    func forRaceSnipe(){
        for i in 0..<alluniv.shared.univList.count {
            for j in 0..<alluniv.shared.univList[i].snipeList.count {
                if alluniv.shared.univList[i].snipeList[j].selected {
                    //個人の追加
                    personal.shared.raceList.append(alluniv.shared.univList[i].snipeList[j])
                }
            }
        }
        aboutUniv()
        raceInformation.shared.update()

    }
    
    //どの大学が参加するかと大学に船情報の追加
    func aboutUniv(){
        //大学の追加と大学に各船の追加
        for i in 0..<personal.shared.raceList.count {
            if group.shared.raceList.count == 0 {
                let new = boats()
                new.univ = personal.shared.raceList[i].univ
                new.boat.append(personal.shared.raceList[i])
                group.shared.raceList.append(new)
            }else {
                var isInsert = false
                //既存の大学と一致しなかったら追加する
                hantei:for j in 0..<alluniv.shared.univList.count{
                    if alluniv.shared.univList[j].univ == personal.shared.raceList[i].univ {
                        //レースに出る団体に追加する
                        for k in 0..<group.shared.raceList.count {
                            if group.shared.raceList[k].univ == personal.shared.raceList[i].univ{
                                group.shared.raceList[k].boat.append(personal.shared.raceList[i])
                                break hantei
                            }
                        }
                    }
                    //最後まで一致しなかったら
                    if j == alluniv.shared.univList.count-1{
                        isInsert = true
                    }
                }
                if isInsert {
                    //一致しなかったら追加する
                    let new = boats()
                    new.univ = personal.shared.raceList[i].univ
                    new.boat.append(personal.shared.raceList[i])
                    group.shared.raceList.append(new)
                }
                
            }
        }
    }
    

    
}

