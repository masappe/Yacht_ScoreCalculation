
//
//  RaceResultViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/07/02.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class RaceResultViewController: UIViewController,UITabBarDelegate,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tableView: UITableView!
    var state:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果"
        


    }
    //tabbarの状態
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            dismiss(animated: true, completion: nil)
        case 2:
            cutRaceResult()
            state = "cutResult"
            tableView.reloadData()
        case 3:
            raceResult()
            state = "Result"
            tableView.reloadData()
        default:
            break
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if state == "cutResult" {
            return "カットレースの結果"
        }
        if state == "Result" {
            return "カットレースなしの結果"
        }
        return ""
    }
    //tableviewのセルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return raceInformation.shared.raceList.count
    }
    //tableviewのセル情報
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if state == "cutResult" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = "\(indexPath.row+1)位 艇番:\(raceInformation.shared.raceList[indexPath.row].boatNumber!) 合計:\(raceInformation.shared.raceList[indexPath.row].cutPoint)点"
            return cell!
        }
        if state == "Result" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = "\(indexPath.row+1)位 艇番:\(raceInformation.shared.raceList[indexPath.row].boatNumber!) 合計:\(raceInformation.shared.raceList[indexPath.row].totalPoint)点"
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
    
    //セルをたっぷした時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPersonal", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPersonal" {
            let personalViewController = segue.destination as! PersonalViewController
            personalViewController.num = sender as! Int?
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


}
