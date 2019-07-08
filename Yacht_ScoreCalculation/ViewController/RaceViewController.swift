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
//    var tempBoat:[boat] = []
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
//        //listを一時格納
//        for i in 0..<raceInformation.shared.raceList.count {
//            tempBoat.append(raceInformation.shared.raceList[i])
//        }

        // Do any additional setup after loading the view.
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
            cell?.textLabel?.text = afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][indexPath.row].boatNumber
            return cell!
        }
        if tableView.tag ==  2 {
            let cell = beforeTableView.dequeueReusableCell(withIdentifier: "before")
            cell?.textLabel?.text = beforeGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][indexPath.row].boatNumber
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
        }
        titleLabel.title = "\(raceInformation.shared.currentRaceNumber)レース目"
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
//            print(raceInformation.shared.raceList[0].racePoint)
            for i in 0..<raceInformation.shared.raceList.count{
//                raceInformation.shared.raceList[i].racePoint.append(1000)
                raceInformation.shared.cutResultList[i].racePoint.append(1000)
            }
//            print(raceInformation.shared.raceList[0].racePoint)

            //現在のレース結果を格納
            if raceInformation.shared.raceCount >= raceInformation.shared.cutRaceNumber {
                beforeGoalBoat.shared.list.append(raceInformation.shared.cutResultList)
            }else {
                beforeGoalBoat.shared.list.append(raceInformation.shared.raceList)
            }


        }
        titleLabel.title = "\(raceInformation.shared.currentRaceNumber)レース目"
        afterTableView.reloadData()
        beforeTableView.reloadData()
        //アラートの処理を入れる
        
    }
    
    //レースの結果を更新する
    @IBAction func updateRaceResult(_ sender: Any) {
        //全ての船のレース結果の更新
        for i in 0..<afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1].count {
            //レース数が追加されるとracepointをアペンドする
            for j in 0..<raceInformation.shared.raceList.count {
//                if raceInformation.shared.raceCount == raceInformation.shared.raceList[j].racePoint.count {
//                    raceInformation.shared.raceList[j].racePoint.append(1000)
//                    raceInformation.shared.cutResultList[j].racePoint.append(1000)
//                }
                //現在のレースの結果を付与
                //racepoint,currentracepointを更新

                if afterGoalBoat.shared.list[raceInformation.shared.currentRaceNumber-1][i].boatNumber == raceInformation.shared.raceList[j].boatNumber {
                    raceInformation.shared.raceList[j].currentRacePoint = i + 1
                    raceInformation.shared.raceList[j].racePoint[raceInformation.shared.currentRaceNumber-1] = i + 1
                    raceInformation.shared.cutResultList[j].currentRacePoint = i + 1
                    raceInformation.shared.cutResultList[j].racePoint[raceInformation.shared.currentRaceNumber-1] = i + 1

                    break
                }
                
            }
        }
//            //現在のレースの結果を付与
//            raceInformation.shared.raceList[i].insertRacePoint()
//            raceInformation.shared.cutResultList[i].insertRacePoint()
        for i in 0..<raceInformation.shared.raceList.count{
            //現在までのレースの合計点を付与
            raceInformation.shared.raceList[i].calculateRacePoint()
            raceInformation.shared.cutResultList[i].calculateRacePoint()
        }
        //レースの順位を計算する
        cutRaceResult()
        raceResult()
//        print("raceInfomation-----------------------")
//        for i in 0..<raceInformation.shared.raceList.count{
//            print(raceInformation.shared.raceList[i].boatNumber)
//            print(raceInformation.shared.raceList[i].racePoint)
//        }
//        print("-----------------------")

        
    }
    
    //ソートする
    //cutレースの時の順位の計算
    func cutRaceResult() {
        raceInformation.shared.cutResultList.sort{ $0.cutPoint < $1.cutPoint }
        for i in 0..<raceInformation.shared.cutResultList.count {
            raceInformation.shared.cutResultList[i].cutResult = i + 1
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
            performSegue(withIdentifier: "toRaceResult", sender: "cutResult")
        case 3:
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
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //終了ボタン
    @IBAction func degugButoon(_ sender: Any) {
        for i in 0..<raceInformation.shared.raceList.count{
            print("-----------------------cut")
            print("\(raceInformation.shared.raceList[i].boatNumber!)番  \(raceInformation.shared.raceList[i].totalPoint!)点  \(raceInformation.shared.raceList[i].racePoint)")
            print("\(raceInformation.shared.cutResultList[i].boatNumber!)番  \(raceInformation.shared.cutResultList[i].cutPoint!)点  \(raceInformation.shared.cutResultList[i].racePoint)")

        }
        
    }
    
}
