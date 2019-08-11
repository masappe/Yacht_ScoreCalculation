
//
//  PersonalRaceResultViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/07/02.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit
import RealmSwift

protocol TableViewPersonalControllerDelegate {
    func reloadTableView()
}

class PersonalRaceResultViewController: UIViewController,UITabBarDelegate,UITableViewDelegate,UITableViewDataSource,TableViewPersonalControllerDelegate {

    @IBOutlet weak var titleLabel: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    //true:カットなし，false:カットあり
    var state = true
    //realm
    let realm = try! Realm()
    var Personal: Results<personal>!
    var RaceInformation: Results<raceInformation>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //realm
        Personal = realm.objects(personal.self)
        RaceInformation = realm.objects(raceInformation.self)

    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //セクション
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if state {
            return "カットレースなしの結果"
        } else {
            return "カットレースの結果"
        }
    }

    //tableviewのセルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Personal[0].raceList.count
    }

    //tableviewのセル情報
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if state {
            cell?.textLabel?.text = "\(indexPath.row+1)位 艇番:\(Personal[0].raceList[indexPath.row].boatNumber)(\(Personal[0].raceList[indexPath.row].skipper)) 合計:\(Personal[0].raceList[indexPath.row].totalPoint)点"
        } else {
            cell?.textLabel?.text = "\(indexPath.row+1)位 艇番:\(Personal[0].raceList[indexPath.row].boatNumber)(\(Personal[0].raceList[indexPath.row].skipper)) 合計:\(Personal[0].raceList[indexPath.row].cutPoint)点"
        }
        switch Personal[0].raceList[indexPath.row].selectColor {
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
            personalViewController.state = true
            personalViewController.noCut = state
            personalViewController.tableViewPersonalControllerDelegate = self
        }
    }
    
    //noCutResult
    @IBAction func noCutButton(_ sender: Any) {
        raceResult()
        state = true
        tableView.reloadData()
        titleLabel.title = "\(RaceInformation[0].raceCount)レースまでの結果"

    }
    //cutResult
    @IBAction func cutButton(_ sender: Any) {
        cutRaceResult()
        state = false
        tableView.reloadData()
        titleLabel.title = "\(RaceInformation[0].raceCount)レースまでの結果(cut有り)"

    }
    //Result
    @IBAction func nowResult(_ sender: Any) {
        if RaceInformation[0].raceCount >= RaceInformation[0].cutRaceNumber {
            cutRaceResult()
            state = false
            tableView.reloadData()
            titleLabel.title = "\(RaceInformation[0].raceCount)レースまでの結果(cut有り)"
        } else {
            raceResult()
            state = true
            tableView.reloadData()
            titleLabel.title = "\(RaceInformation[0].raceCount)レースまでの結果"
        }
    }
    
    //レース順位のソート
    //cutレースの時の順位の計算
    func cutRaceResult() {
        try! realm.write {
            Personal[0].raceList.sort{ $0.cutPoint < $1.cutPoint }
            for i in 0..<Personal[0].raceList.count {
                Personal[0].raceList[i].cutResult = i + 1
            }
        }
    }
    //cutレースがない時の順位の計算
    func raceResult() {
        try! realm.write {
            Personal[0].raceList.sort{$0.totalPoint < $1.totalPoint}
            for i in 0..<Personal[0].raceList.count {
                Personal[0].raceList[i].result = i + 1
            }
        }
    }
}
