
//
//  RaceResultViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/07/02.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class PersonalRaceResultViewController: UIViewController,UITabBarDelegate,UITableViewDelegate,UITableViewDataSource {

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
        return personal.shared.raceList.count
    }

    //tableviewのセル情報
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "\(indexPath.row+1)位 艇番:\(personal.shared.raceList[indexPath.row].boatNumber!) 合計:\(personal.shared.raceList[indexPath.row].totalPoint)点"
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
    
    //noCutResult
    @IBAction func noCutButton(_ sender: Any) {
        raceResult()
        state = true
        tableView.reloadData()
        titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果"

    }
    //cutResult
    @IBAction func cutButton(_ sender: Any) {
        cutRaceResult()
        state = false
        tableView.reloadData()
        titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果(cut有り)"

    }
    //Result
    @IBAction func nowResult(_ sender: Any) {
        if raceInformation.shared.raceCount >= raceInformation.shared.cutRaceNumber {
            cutRaceResult()
            state = false
            tableView.reloadData()
            titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果(cut有り)"
        } else {
            raceResult()
            state = true
            tableView.reloadData()
            titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果"
        }
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


}
