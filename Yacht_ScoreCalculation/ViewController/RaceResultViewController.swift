
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
            state = "cutResult"
            tableView.reloadData()
        case 3:
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
        if state == "cutResult" {
            return raceInformation.shared.cutResultList.count
            
        }
        if state == "Result" {
            return raceInformation.shared.raceList.count
        }
        return 0
    }
    //tableviewのセル情報
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if state == "cutResult" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = "\(indexPath.row+1)位 \(raceInformation.shared.cutResultList[indexPath.row].boatNumber) \(raceInformation.shared.cutResultList[indexPath.row].cutPoint)点"
            return cell!
        }
        if state == "Result" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = "\(indexPath.row+1)位 \(raceInformation.shared.raceList[indexPath.row].boatNumber) \(raceInformation.shared.cutResultList[indexPath.row].totalPoint)点"
            return cell!
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }


}
