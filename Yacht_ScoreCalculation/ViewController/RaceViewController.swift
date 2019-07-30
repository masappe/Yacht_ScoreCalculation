//
//  RaceViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/30.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class RaceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate {
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    //回航前
    @IBOutlet weak var beforeTableView: UITableView!
    //回航後
    @IBOutlet weak var afterTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        afterTableView.delegate = self
        afterTableView.dataSource = self
        beforeTableView.delegate = self
        beforeTableView.dataSource = self
        //要素を追加する前に配列を作成する
//        afterGoalBoat.shared.list.removeAll()
//        beforeGoalBoat.shared.list.removeAll()
        //最初だけ追加
        //なんかよくわからん
        if raceInformation.shared.raceCount == 1 {
            afterGoalBoat.shared.list.append([boat]())
            beforeGoalBoat.shared.list.append(personal.shared.raceList)
        }
        //cutレースかどうかでタイトルを変える
        if raceInformation.shared.currentRaceNumber >= raceInformation.shared.cutRaceNumber {
            titleLabel.title = "\(raceInformation.shared.currentRaceNumber)レース目(cut有り)"
        }else {
            titleLabel.title = "\(raceInformation.shared.currentRaceNumber)レース目"
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
            return afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1].count
        }
        if tableView.tag ==  2 {
            return beforeGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1].count
        }
        return 0
    }
    
    //表示するデータの代入
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = afterTableView.dequeueReusableCell(withIdentifier: "after")
            cell?.textLabel?.text = "\(String(afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][indexPath.row].boatNumber))(\(afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][indexPath.row].skipper!))"
            if indexPath.row % 2 == 0 {
                cell?.backgroundColor = .clearGreen
            }
            return cell!
        }
        if tableView.tag ==  2 {
            let cell = beforeTableView.dequeueReusableCell(withIdentifier: "before")
            cell?.textLabel?.text = "\(String(beforeGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][indexPath.row].boatNumber))(\(beforeGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][indexPath.row].skipper!))"
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
            afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1].append(beforeGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][indexPath.row])
            beforeGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1].remove(at: indexPath.row)
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
                beforeGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1].append(afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][indexPath.row])
                afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1].remove(at: indexPath.row)
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
        if raceInformation.shared.currentRaceNumber >= 2{
            raceInformation.shared.currentRaceNumber = raceInformation.shared.currentRaceNumber - 1
        } else {
            let alert = UIAlertController(title: "無理", message: "これ以上前に戻れません", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        //cutレースかどうかでタイトルを変える
        if raceInformation.shared.currentRaceNumber >= raceInformation.shared.cutRaceNumber {
            titleLabel.title = "\(raceInformation.shared.currentRaceNumber)レース目(cut有り)"
        }else {
            titleLabel.title = "\(raceInformation.shared.currentRaceNumber)レース目"
        }
        afterTableView.reloadData()
        beforeTableView.reloadData()

    }
    //次のレースへ
    @IBAction func nextRaceButton(_ sender: Any) {
        //レース数の更新
        raceInformation.shared.currentRaceNumber = raceInformation.shared.currentRaceNumber + 1
        if raceInformation.shared.raceCount < raceInformation.shared.currentRaceNumber {
            //アラートで次のレースに進むかの確認
            let alert = UIAlertController(title: "次のレースへ進む", message: "第\(raceInformation.shared.currentRaceNumber)レースに進みますか？", preferredStyle: .alert)
            //OKボタンの時の処理
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                //１回のみ行われる
                raceInformation.shared.raceCount = raceInformation.shared.currentRaceNumber
                afterGoalBoat.shared.list.append([boat]())
                //次のレースに進むときはアペンドする
                //個人
                for i in 0..<personal.shared.raceList.count{
                    personal.shared.raceList[i].racePoint.append(raceInformation.shared.DNF)
                    personal.shared.raceList[i].cutSelect.append(false)
                }
                //団体
                for i in 0..<group.shared.raceList.count {
                    group.shared.raceList[i].racePoint.append(0)
                }
                //現在のレース結果を格納
                //レース結果をソートしてその結果をbeforeに格納
                //cutレースかどうかで格納するものを変える
                if raceInformation.shared.raceCount >= raceInformation.shared.cutRaceNumber {
                    self.cutRaceResult()
                }else {
                    self.raceResult()
                }
                beforeGoalBoat.shared.list.append(personal.shared.raceList)
                //cutレースかどうかでタイトルを変える
                if raceInformation.shared.currentRaceNumber >= raceInformation.shared.cutRaceNumber {
                    self.titleLabel.title = "\(raceInformation.shared.currentRaceNumber)レース目(cut有り)"
                }else {
                    self.titleLabel.title = "\(raceInformation.shared.currentRaceNumber)レース目"
                }
                self.afterTableView.reloadData()
                self.beforeTableView.reloadData()

            }
            //cancelならひく１
            let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: {(action) in
                raceInformation.shared.currentRaceNumber = raceInformation.shared.currentRaceNumber - 1

            })
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        } else {
            //cutレースかどうかでタイトルを変える
            if raceInformation.shared.currentRaceNumber >= raceInformation.shared.cutRaceNumber {
                titleLabel.title = "\(raceInformation.shared.currentRaceNumber)レース目(cut有り)"
            }else {
                titleLabel.title = "\(raceInformation.shared.currentRaceNumber)レース目"
            }
            afterTableView.reloadData()
            beforeTableView.reloadData()
        }
        
    }
    
    //レースの結果を更新する
    @IBAction func updateRaceResult(_ sender: Any) {
        let alert = UIAlertController(title: "更新", message: "第\(raceInformation.shared.currentRaceNumber)レースのレース結果を更新してもよろしいですか？", preferredStyle: .alert)
        //OKボタンの時の処理
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            //全ての船のレース結果の更新
            //beforeGoalだったら英語がつく
            //afterGoalだったら得点がつく
            for i in 0..<personal.shared.raceList.count {
                var find = false
                //Goalした船の得点計算
                for j in 0..<afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1].count {
                    if afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][j].boatNumber == personal.shared.raceList[i].boatNumber {
                        personal.shared.raceList[i].racePoint[raceInformation.shared.currentRaceNumber-1] = j + 1
                        find = true
                        break
                    }
                }
                //Goalしてない船の得点計算
                if !find {
                    for k in 0..<beforeGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1].count {
                        if beforeGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][k].boatNumber == personal.shared.raceList[i].boatNumber {
                            personal.shared.raceList[i].racePoint[raceInformation.shared.currentRaceNumber-1] = raceInformation.shared.DNF
                            break
                            
                        }
                    }
                }
            }
            //艇ごとの現在までのレースの合計点を計算
            for i in 0..<personal.shared.raceList.count{
                personal.shared.raceList[i].calculateRacePoint()
            }
            //大学ごとの現在までのレースの合計点を計算
            for i in 0..<group.shared.raceList.count{
                var sum = 0
                //船の合計点を反映させる
                for j in 0..<group.shared.raceList[i].boat.count{
                    sum = sum + group.shared.raceList[i].boat[j].racePoint[raceInformation.shared.currentRaceNumber-1]
                }
                group.shared.raceList[i].racePoint[raceInformation.shared.currentRaceNumber-1] = sum
                //total,badpointの計算
                group.shared.raceList[i].calculateRacePoint()
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
        personal.shared.raceList.sort{ $0.cutPoint < $1.cutPoint }
        for i in 0..<personal.shared.raceList.count {
            personal.shared.raceList[i].cutResult = i + 1
        }
    }
    //cutレースがない時の順位の計算
    func raceResult() {
        personal.shared.raceList.sort{$0.totalPoint < $1.totalPoint}
        for i in 0..<personal.shared.raceList.count {
            personal.shared.raceList[i].result = i + 1
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
