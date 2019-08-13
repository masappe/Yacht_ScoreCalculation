//
//  RaceViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/30.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit
import RealmSwift

class RaceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate {
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    //回航前
    @IBOutlet weak var beforeTableView: UITableView!
    //回航後
    @IBOutlet weak var afterTableView: UITableView!
    //realm
    let realm = try! Realm()
    var Personal: Results<personal>!
    var Group: Results<group>!
    var RaceInformation: Results<raceInformation>!
    var BeforeGoalBoat: Results<beforeGoalBoat>!
    var AfterGoalBoat: Results<afterGoalBoat>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //realm
        Personal = realm.objects(personal.self)
        Group = realm.objects(group.self)
        RaceInformation = realm.objects(raceInformation.self)
        BeforeGoalBoat = realm.objects(beforeGoalBoat.self)
        AfterGoalBoat = realm.objects(afterGoalBoat.self)

        afterTableView.delegate = self
        afterTableView.dataSource = self
        beforeTableView.delegate = self
        beforeTableView.dataSource = self
        //cutレースかどうかでタイトルを変える
        if RaceInformation[0].currentRaceNumber >= RaceInformation[0].cutRaceNumber {
            titleLabel.title = "\(RaceInformation[0].currentRaceNumber)レース目(cut有り)"
        }else {
            titleLabel.title = "\(RaceInformation[0].currentRaceNumber)レース目"
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == afterTableView {
            return "フィニッシュ"
        } else {
            return "レース中"
        }
    }
    
    //tableviewの表示
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return AfterGoalBoat[RaceInformation[0].currentRaceNumber-1].list.count
        }
        if tableView.tag ==  2 {
            return BeforeGoalBoat[RaceInformation[0].currentRaceNumber-1].list.count
        }
        return 0
    }
    
    //表示するデータの代入
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = afterTableView.dequeueReusableCell(withIdentifier: "after")
            cell?.textLabel?.text = "\(indexPath.row+1)位:\(String(AfterGoalBoat[RaceInformation[0].currentRaceNumber-1].list[indexPath.row].boatNumber))(\(AfterGoalBoat[RaceInformation[0].currentRaceNumber-1].list[indexPath.row].skipper))"
            if indexPath.row % 2 == 0 {
                cell?.backgroundColor = .clearGreen
            }
            return cell!
        }
        if tableView.tag ==  2 {
            let cell = beforeTableView.dequeueReusableCell(withIdentifier: "before")
            cell?.textLabel?.text = "\(indexPath.row+1)位:\(String(BeforeGoalBoat[RaceInformation[0].currentRaceNumber-1].list[indexPath.row].boatNumber))(\(BeforeGoalBoat[RaceInformation[0].currentRaceNumber-1].list[indexPath.row].skipper))"
            if indexPath.row % 2 == 0 {
                cell?.backgroundColor = .clearGreen
            }

            return cell!
        }
        let cell = afterTableView.dequeueReusableCell(withIdentifier: "after")
        return cell!
    }
    
    //セルをタップした時の処理
    //タップしたらbeforeからafterに移動する
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        if tableView.tag == 2 {
            try! realm.write {
                AfterGoalBoat[RaceInformation[0].currentRaceNumber-1].list.append(BeforeGoalBoat[RaceInformation[0].currentRaceNumber-1].list[indexPath.row])
                BeforeGoalBoat[RaceInformation[0].currentRaceNumber-1].list.remove(at: indexPath.row)
            }
            afterTableView.reloadData()
            beforeTableView.reloadData()
            
        }
    }
    
    //セルの削除する時の処理
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == afterTableView {
            //削除の設定
            let delete = UIContextualAction(style: .destructive, title: "delete", handler: {(action,sourceView,completionHandler) in
                completionHandler(true)
                try! self.realm.write {
                    self.BeforeGoalBoat[self.RaceInformation[0].currentRaceNumber-1].list.append(self.AfterGoalBoat[self.RaceInformation[0].currentRaceNumber-1].list[indexPath.row])
                    self.AfterGoalBoat[self.RaceInformation[0].currentRaceNumber-1].list.remove(at: indexPath.row)
                }
                self.afterTableView.reloadData()
                self.beforeTableView.reloadData()
            })
            delete.backgroundColor = .red
            
            return UISwipeActionsConfiguration(actions: [delete])

        }
        return UISwipeActionsConfiguration(actions: [])

    }
    //前のレースへ
    @IBAction func backRaceButton(_ sender: Any) {
        //レース数の更新
        if RaceInformation[0].currentRaceNumber >= 2{
            try! realm.write {
                RaceInformation[0].currentRaceNumber = RaceInformation[0].currentRaceNumber - 1
            }
        } else {
            let alert = UIAlertController(title: "無理", message: "これ以上前に戻れません", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        //cutレースかどうかでタイトルを変える
        if RaceInformation[0].currentRaceNumber >= RaceInformation[0].cutRaceNumber {
            titleLabel.title = "\(RaceInformation[0].currentRaceNumber)レース目(cut有り)"
        }else {
            titleLabel.title = "\(RaceInformation[0].currentRaceNumber)レース目"
        }
        afterTableView.reloadData()
        beforeTableView.reloadData()

    }
    //次のレースへ
    @IBAction func nextRaceButton(_ sender: Any) {
        try! realm.write {
            //レース数の更新
            RaceInformation[0].currentRaceNumber = RaceInformation[0].currentRaceNumber + 1
        }
        //次のレースに進むかどうか
        if RaceInformation[0].raceCount < RaceInformation[0].currentRaceNumber {
            //レースの更新をしているかどうかの確認
            if RaceInformation[0].raceCount == RaceInformation[0].doneUpdateCount {
                //アラートで次のレースに進むかの確認
                let alert = UIAlertController(title: "次のレースへ進む", message: "第\(RaceInformation[0].currentRaceNumber)レースに進みますか？", preferredStyle: .alert)
                //OKボタンの時の処理
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                    try! self.realm.write {
                        //１回のみ行われる
                        self.RaceInformation[0].raceCount = self.RaceInformation[0].currentRaceNumber
                        let after = afterGoalBoat()
                        self.realm.add(after)
                        //次のレースに進むときはアペンドする
                        //個人
                        for i in 0..<self.Personal[0].raceList.count{
                            self.Personal[0].raceList[i].racePoint.append(self.RaceInformation[0].DNF)
                            self.Personal[0].raceList[i].cutSelect.append(false)
                        }
                        //団体
                        for i in 0..<self.Group[0].raceList.count {
                            self.Group[0].raceList[i].racePoint.append(0)
                        }
                        //現在のレース結果を格納
                        //レース結果をソートしてその結果をbeforeに格納
                        //cutレースかどうかで格納するものを変える
                        if self.RaceInformation[0].raceCount >= self.RaceInformation[0].cutRaceNumber {
                            self.cutRaceResult()
                        }else {
                            self.raceResult()
                        }
                        let before = beforeGoalBoat()
                        self.realm.add(before)
                        for i in self.Personal[0].raceList{
                            self.BeforeGoalBoat[self.RaceInformation[0].currentRaceNumber-1].list.append(i)
                        }
                    }
                    //cutレースかどうかでタイトルを変える
                    if self.RaceInformation[0].currentRaceNumber >= self.RaceInformation[0].cutRaceNumber {
                        self.titleLabel.title = "\(self.RaceInformation[0].currentRaceNumber)レース目(cut有り)"
                    }else {
                        self.titleLabel.title = "\(self.RaceInformation[0].currentRaceNumber)レース目"
                    }
                    self.afterTableView.reloadData()
                    self.beforeTableView.reloadData()
                    
                }
                //cancelならひく１
                let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: {(action) in
                    try! self.realm.write {
                        self.RaceInformation[0].currentRaceNumber = self.RaceInformation[0].currentRaceNumber - 1
                    }
                    
                })
                alert.addAction(ok)
                alert.addAction(cancel)
                present(alert, animated: true, completion: nil)

            } else {
                try! realm.write {
                    RaceInformation[0].currentRaceNumber = RaceInformation[0].currentRaceNumber - 1
                }
                let alert = UIAlertController(title: "エラー", message: "レースの更新をしてください", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }
        } else {
            //cutレースかどうかでタイトルを変える
            if RaceInformation[0].currentRaceNumber >= RaceInformation[0].cutRaceNumber {
                titleLabel.title = "\(RaceInformation[0].currentRaceNumber)レース目(cut有り)"
            }else {
                titleLabel.title = "\(RaceInformation[0].currentRaceNumber)レース目"
            }
            afterTableView.reloadData()
            beforeTableView.reloadData()
        }
        
    }
    
    //レースの結果を更新する
    @IBAction func updateRaceResult(_ sender: Any) {
        let alert = UIAlertController(title: "更新", message: "第\(RaceInformation[0].currentRaceNumber)レースのレース結果を更新してもよろしいですか？", preferredStyle: .alert)
        //OKボタンの時の処理
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            try! self.realm.write {
                //更新ボタンを押したことを更新
                if self.RaceInformation[0].doneUpdateCount + 1 == self.RaceInformation[0].raceCount {
                    self.RaceInformation[0].doneUpdateCount += 1
                }
                //全ての船のレース結果の更新
                //beforeGoalだったら英語がつく
                //afterGoalだったら得点がつく
                for i in 0..<self.Personal[0].raceList.count {
                    var find = false
                    //Goalした船の得点計算
                    for j in 0..<self.AfterGoalBoat[self.RaceInformation[0].currentRaceNumber-1].list.count {
                        if self.AfterGoalBoat[self.RaceInformation[0].currentRaceNumber-1].list[j].boatNumber == self.Personal[0].raceList[i].boatNumber {
                            self.Personal[0].raceList[i].racePoint[self.RaceInformation[0].currentRaceNumber-1] = j + 1
                            
                            find = true
                            break
                        }
                    }
                    //Goalしてない船の得点計算
                    if !find {
                        for k in 0..<self.BeforeGoalBoat[self.RaceInformation[0].currentRaceNumber-1].list.count {
                            if self.BeforeGoalBoat[self.RaceInformation[0].currentRaceNumber-1].list[k].boatNumber == self.Personal[0].raceList[i].boatNumber {
                                self.Personal[0].raceList[i].racePoint[self.RaceInformation[0].currentRaceNumber-1] = self.RaceInformation[0].DNF
                                break
                                
                            }
                        }
                    }

                }
                //艇ごとの現在までのレースの合計点を計算
                for i in 0..<self.Personal[0].raceList.count{
                    self.Personal[0].raceList[i].calculateRacePoint()
                }
                //大学ごとの現在までのレースの合計点を計算
                for i in 0..<self.Group[0].raceList.count{
                    var sum = 0
                    //船の合計点を反映させる
                    for j in 0..<self.Group[0].raceList[i].boat.count{
                        sum = sum + self.Group[0].raceList[i].boat[j].racePoint[self.RaceInformation[0].currentRaceNumber-1]
                    }
                    self.Group[0].raceList[i].racePoint[self.RaceInformation[0].currentRaceNumber-1] = sum
                    //total,badpointの計算
                    self.Group[0].raceList[i].calculateRacePoint()
                }
            }

        }
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    //レース順位のソート
    //cutレースの時の順位の計算
    func cutRaceResult() {
        Personal[0].raceList.sort{ $0.cutPoint < $1.cutPoint }
        for i in 0..<Personal[0].raceList.count {
            Personal[0].raceList[i].cutResult = i + 1
        }
    }
    //cutレースがない時の順位の計算
    func raceResult() {
        Personal[0].raceList.sort{$0.totalPoint < $1.totalPoint}
        for i in 0..<Personal[0].raceList.count {
            Personal[0].raceList[i].result = i + 1
        }
    }
    
    //戻るボタン
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //終了ボタン
    @IBAction func endRaceButoon(_ sender: Any) {
        let alert = UIAlertController(title: "終了", message: "レースを終了させてよろしいですか", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.performSegue(withIdentifier: "toFinish", sender: nil)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}
