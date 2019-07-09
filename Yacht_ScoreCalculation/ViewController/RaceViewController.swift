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
    @IBOutlet weak var tabBar: UITabBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        afterTableView.delegate = self
        afterTableView.dataSource = self
        beforeTableView.delegate = self
        beforeTableView.dataSource = self
        tabBar.delegate = self
        //要素を追加する前に配列を作成する
        afterGoalBoat.shared.list.removeAll()
        beforeGoalBoat.shared.list.removeAll()
        afterGoalBoat.shared.list.append([boat]())
        beforeGoalBoat.shared.list.append(raceInformation.shared.raceList)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView.tag == 1 {
            return "レース終了リスト"
        }
        if tableView.tag == 2 {
            return "残っている船リスト"
        }
        return nil
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
            cell?.textLabel?.text = String(afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][indexPath.row].boatNumber)
            return cell!
        }
        if tableView.tag ==  2 {
            let cell = beforeTableView.dequeueReusableCell(withIdentifier: "before")
            cell?.textLabel?.text = String(beforeGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][indexPath.row].boatNumber)
            return cell!
        }
        let cell = afterTableView.dequeueReusableCell(withIdentifier: "after")
        return cell!
    }
    
    //セルをタップした時の処理
    //タップしたらbeforeからafterに移動する
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 1 {            beforeGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1].append(afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][indexPath.row])
            afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1].remove(at: indexPath.row)
            afterTableView.reloadData()
            beforeTableView.reloadData()

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
            //１回のみ行われる
            raceInformation.shared.raceCount = raceInformation.shared.currentRaceNumber
            afterGoalBoat.shared.list.append([boat]())
            //よくわからんけど一つのappendで大丈夫
            for i in 0..<raceInformation.shared.raceList.count{
                raceInformation.shared.raceList[i].racePoint.append(raceInformation.shared.DNF)
            }

            //現在のレース結果を格納
            //レース結果をソートしてその結果をbeforeに格納
            //cutレースかどうかで格納するものを変える
            if raceInformation.shared.raceCount >= raceInformation.shared.cutRaceNumber {
                cutRaceResult()
            }else {
                raceResult()
            }
            beforeGoalBoat.shared.list.append(raceInformation.shared.raceList)
        }
        //cutレースかどうかでタイトルを変える
        if raceInformation.shared.currentRaceNumber >= raceInformation.shared.cutRaceNumber {
            titleLabel.title = "\(raceInformation.shared.currentRaceNumber)レース目(cut有り)"
        }else {
            titleLabel.title = "\(raceInformation.shared.currentRaceNumber)レース目"
        }
        afterTableView.reloadData()
        beforeTableView.reloadData()
        //アラートの処理を入れる
        
    }
    
    //レースの結果を更新する
    @IBAction func updateRaceResult(_ sender: Any) {
        //全ての船のレース結果の更新
        //beforeGoalだったら英語がつく
        //afterGoalだったら得点がつく
        for i in 0..<raceInformation.shared.raceList.count {
            var find = false
            for j in 0..<afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1].count {
                if afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][j].boatNumber == raceInformation.shared.raceList[i].boatNumber {
//                    raceInformation.shared.raceList[i].currentRacePoint = j + 1
                    raceInformation.shared.raceList[i].racePoint[raceInformation.shared.currentRaceNumber-1] = j + 1
                    find = true
                    break
                }
            }
            if !find {
                for k in 0..<beforeGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1].count {
                    if beforeGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][k].boatNumber == raceInformation.shared.raceList[i].boatNumber {
//                        raceInformation.shared.raceList[i].currentRacePoint = raceInformation.shared.DNF
                        raceInformation.shared.raceList[i].racePoint[raceInformation.shared.currentRaceNumber-1] = raceInformation.shared.DNF
                        break

                    }
                }
            }
        }
        //艇ごとの現在までのレースの合計点を計算
        for i in 0..<raceInformation.shared.raceList.count{
            raceInformation.shared.raceList[i].calculateRacePoint()
        }
        
    }
    
    //レース順位のソート
    //cutレースの時の順位の計算
    func cutRaceResult() {
        raceInformation.shared.raceList.sort{ $0.cutPoint < $1.cutPoint }
        for i in 0..<raceInformation.shared.raceList.count {
            raceInformation.shared.raceList[i].cutResult = i + 1
        }
    }
    //cutレースがない時の順位の計算
    func raceResult() {
        raceInformation.shared.raceList.sort{$0.totalPoint < $1.totalPoint}
        for i in 0..<raceInformation.shared.raceList.count {
            raceInformation.shared.raceList[i].result = i + 1
        }
    }

    //tabbarの状態
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1: break
            
        case 2:
            //カットレースの順位を計算しソートする
            cutRaceResult()
            performSegue(withIdentifier: "toRaceResult", sender: "cutResult")
        case 3:
            //レースの順位を計算しソートする
            raceResult()
            performSegue(withIdentifier: "toRaceResult", sender: "Result")
        default:
            break
        }
    }
    //遷移する前
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRaceResult" {
            let raceResultViewController = segue.destination as! RaceResultViewController
            raceResultViewController.state = sender as! String?
        }
    }
    
    //戻るボタン
    //全てのデータを削除する
    @IBAction func backButton(_ sender: Any) {
        //アラートで確認
        let alert = UIAlertController(title: "前の画面に戻る", message: "レースの全てのデータが削除されますがよろしいですか？", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler:{ action in
            self.dismiss(animated: true, completion: {
                raceInformation.shared.initialize()
            })

        })
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    //終了ボタン
    @IBAction func degugButoon(_ sender: Any) {
        raceResult()
        print("-----------------------MNo cut")

        for i in 0..<raceInformation.shared.raceList.count{
            //艇番　何点　レースの順位
            print("\(i+1)位 \(raceInformation.shared.raceList[i].boatNumber!)番  \(raceInformation.shared.raceList[i].totalPoint)点  \(raceInformation.shared.raceList[i].racePoint)")
        }
        print("-----------------------end")
        cutRaceResult()
        print("-----------------------cut")

        for i in 0..<raceInformation.shared.raceList.count{
            //艇番　何点　レースの順位
            print("\(i+1)位\(raceInformation.shared.raceList[i].boatNumber!)番  \(raceInformation.shared.raceList[i].cutPoint)点  \(raceInformation.shared.raceList[i].racePoint)")
            
        }
        print("-----------------------end")
        print("----------------------finish")


    }
    
}
