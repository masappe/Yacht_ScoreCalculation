

//
//  GroupRaceResultViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/07/19.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class GroupRaceResultViewController: UIViewController,UITabBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    //true:カットなし，false:カットあり
    var state = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if state {
            titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果"
        } else {
            titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果(cut有り)"
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if state {
            return "カットレースなしの結果"
        } else {
            return "カットレースの結果"
        }
    }
    
    //tableviewのセルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group.shared.raceList.count
    }
    
    //tableviewのセル情報
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if state {
            cell?.textLabel?.text = "\(indexPath.row+1)位 大学名:\(group.shared.raceList[indexPath.row].univ!) 合計:\(group.shared.raceList[indexPath.row].totalPoint)点"

        } else {
            cell?.textLabel?.text = "\(indexPath.row+1)位 大学名:\(group.shared.raceList[indexPath.row].univ!) 合計:\(group.shared.raceList[indexPath.row].cutPoint)点"

        }
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
            personalViewController.state = false
        }
    }
    
    //noCutResult
    @IBAction func noCutButton(_ sender: Any) {
        groupRaceResult()
        state = true
        tableView.reloadData()
        titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果"
        
    }
    //cutResult
    @IBAction func cutButton(_ sender: Any) {
        groupCutRaceResult()
        state = false
        tableView.reloadData()
        titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果(cut有り)"
        
    }
    //Result
    @IBAction func nowResult(_ sender: Any) {
        if raceInformation.shared.raceCount >= raceInformation.shared.cutRaceNumber {
            groupCutRaceResult()
            state = false
            tableView.reloadData()
            titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果(cut有り)"
        } else {
            groupRaceResult()
            state = true
            tableView.reloadData()
            titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果"
        }
    }
    
    //団体の順位のソート
    //cutレースの時の順位の計算
    func groupCutRaceResult(){
        group.shared.raceList.sort{ $0.cutPoint < $1.cutPoint }
        for i in 0..<group.shared.raceList.count {
            group.shared.raceList[i].cutResult = i + 1
        }
    }
    //cutレースがない時の順位の計算
    func groupRaceResult(){
        group.shared.raceList.sort{$0.totalPoint < $1.totalPoint}
        for i in 0..<group.shared.raceList.count {
            group.shared.raceList[i].result = i + 1
        }
    }

//    //レース順位のソート
//    //cutレースの時の順位の計算
//    func cutRaceResult() {
//        personal.shared.raceList.sort{ $0.cutPoint < $1.cutPoint }
//        for i in 0..<personal.shared.raceList.count {
//            personal.shared.raceList[i].cutResult = i + 1
//        }
//    }
//    //cutレースがない時の順位の計算
//    func raceResult() {
//        personal.shared.raceList.sort{$0.totalPoint < $1.totalPoint}
//        for i in 0..<personal.shared.raceList.count {
//            personal.shared.raceList[i].result = i + 1
//        }
//    }
    
}
