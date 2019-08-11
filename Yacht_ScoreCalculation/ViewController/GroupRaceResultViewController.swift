

//
//  GroupRaceResultViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/07/19.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit
import RealmSwift

protocol TableViewGroupControllerDelegate {
    func reloadTableView()
}

class GroupRaceResultViewController: UIViewController,UITabBarDelegate,UITableViewDelegate,UITableViewDataSource,TableViewGroupControllerDelegate {
    
    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    //realm
    let realm = try! Realm()
    var Group: Results<group>!
    var RaceInformation: Results<raceInformation>!

    override func viewDidLoad() {
        super.viewDidLoad()
        //realm
        Group = realm.objects(group.self)
        RaceInformation = realm.objects(raceInformation.self)

        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    //セクションの個数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //タイトルのヘッダー
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "カットレースなしの結果"
    }
    
    //tableviewのセルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Group[0].raceList.count
    }
    
    //tableviewのセル情報
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "\(indexPath.row+1)位 大学名:\(Group[0].raceList[indexPath.row].univ!) 合計:\(Group[0].raceList[indexPath.row].totalPoint)点"

        switch Group[0].raceList[indexPath.row].selectColor {
        case "red":
            cell?.backgroundColor = .clearRed
            cell?.textLabel?.backgroundColor = .clear
        case "blue":
            cell?.backgroundColor = .clearBlue
            cell?.textLabel?.backgroundColor = .clear
        case "clear":
            cell?.backgroundColor = .clear
        default:
            break
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
            personalViewController.tableViewGroupControllerDelegate = self
        }
    }
    
    //cutレースがない時の順位の計算
    func groupRaceResult(){
        Group[0].raceList.sort{$0.totalPoint < $1.totalPoint}
        for i in 0..<Group[0].raceList.count {
            Group[0].raceList[i].result = i + 1
        }
    }    
}
