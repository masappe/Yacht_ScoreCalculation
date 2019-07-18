
//
//  RaceResultViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/07/02.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class CutRaceResultViewController: UIViewController,UITabBarDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
//    var state:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //        tabBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果"
        
    }
    @IBAction func debug(_ sender: Any) {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "カットレースの結果"
    }
    //tableviewのセルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personal.shared.raceList.count
    }
    //tableviewのセル情報
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "\(indexPath.row+1)位 艇番:\(personal.shared.raceList[indexPath.row].boatNumber!) 合計:\(personal.shared.raceList[indexPath.row].cutPoint)点"
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
