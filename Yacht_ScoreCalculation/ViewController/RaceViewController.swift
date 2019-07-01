//
//  RaceViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/30.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class RaceViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //回航前
    @IBOutlet weak var beforeTableView: UITableView!
    //回航後
    @IBOutlet weak var afterTableView: UITableView!
    var tempBoat:[boat] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        afterTableView.delegate = self
        afterTableView.dataSource = self
        beforeTableView.delegate = self
        beforeTableView.dataSource = self
        
        //listを一時格納
        for i in 0..<raceInformation.shared.raceList.count {
            tempBoat.append(raceInformation.shared.raceList[i])
        }

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
            return currentResult.shared.list.count
        }
        if tableView.tag ==  2 {
            return tempBoat.count
        }
        return 0
    }
    
    //表示するデータの代入
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = afterTableView.dequeueReusableCell(withIdentifier: "after")
            cell?.textLabel?.text = currentResult.shared.list[indexPath.row].boatNumber
            return cell!
        }
        if tableView.tag ==  2 {
            let cell = beforeTableView.dequeueReusableCell(withIdentifier: "before")
            cell?.textLabel?.text = tempBoat[indexPath.row].boatNumber
            return cell!
        }
        let cell = afterTableView.dequeueReusableCell(withIdentifier: "after")
        return cell!
    }
    
    //セルをタップした時の処理
    //タップしたらbeforeからafterに移動する
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 2 {
            currentResult.shared.list.append(tempBoat[indexPath.row])
            tempBoat.remove(at: indexPath.row)
            afterTableView.reloadData()
            beforeTableView.reloadData()
            
        }
    }
    
    //セルの削除する時の処理
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //削除の設定
        let delete = UIContextualAction(style: .destructive, title: "delete", handler: {(action,sourceView,completionHandler) in
            completionHandler(true)
            self.tempBoat.append(currentResult.shared.list[indexPath.row])
            currentResult.shared.list.remove(at: indexPath.row)
            self.afterTableView.reloadData()
            self.beforeTableView.reloadData()
        })
        delete.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [delete])

    }
    @IBAction func backRaceButton(_ sender: Any) {
        //レース数の更新
        if raceInformation.shared.currentRaceNumber >= 2{
            raceInformation.shared.currentRaceNumber = raceInformation.shared.currentRaceNumber - 1
        }
    }
    @IBAction func nextRaceButton(_ sender: Any) {
        print(raceInformation.shared.currentRaceNumber)
        
        //レース数の更新
        raceInformation.shared.currentRaceNumber = raceInformation.shared.currentRaceNumber + 1
        if raceInformation.shared.raceCount < raceInformation.shared.currentRaceNumber {
            raceInformation.shared.raceCount = raceInformation.shared.currentRaceNumber
        }
        //アラートの処理を入れる
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
