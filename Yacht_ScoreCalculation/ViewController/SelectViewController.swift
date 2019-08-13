//
//  SelectViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/29.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit
import RealmSwift

protocol TableViewControllerDelegate {
    func reloadTableView()
}

class SelectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TableViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    //true:470,false:snipe
    var boatType:Bool = true
    var state = ""
    @IBOutlet weak var titleLabel: UINavigationItem!
    //realm
    let realm = try! Realm()
    var AllUniv: Results<universal>!
    var RaceInformation: Results<raceInformation>!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //realm
        AllUniv = realm.objects(universal.self)
        RaceInformation = realm.objects(raceInformation.self)

        //delegate,datasource
        tableView.delegate = self
        tableView.dataSource = self
        if boatType {
            titleLabel.title = "出場艇の決定(470)"
        } else {
            titleLabel.title = "出場艇の決定(スナイプ)"
        }

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return AllUniv.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return AllUniv[section].univ
    }

    //tableviewの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if boatType {
            return AllUniv[section].fourList.count
        } else {
            return AllUniv[section].snipeList.count

        }
    }
    //tableviewに表示するセルの情報
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if boatType {
            cell?.textLabel?.text = "艇番:\(String(AllUniv[indexPath.section].fourList[indexPath.row].boatNumber))(\(AllUniv[indexPath.section].fourList[indexPath.row].skipper))"
            //選択したのセルのみに色付け
            if (AllUniv[indexPath.section].fourList[indexPath.row].selected) {
                //選択中
                cell!.backgroundColor = .clearGreen
                cell?.textLabel?.backgroundColor = .clear
            } else {
                //未選択
                cell!.backgroundColor = .clear
            }
            return cell!

        } else {
            cell?.textLabel?.text = "艇番:\(String(AllUniv[indexPath.section].snipeList[indexPath.row].boatNumber))(\(AllUniv[indexPath.section].snipeList[indexPath.row].skipper))"
            //選択したのセルのみに色付け
            if (AllUniv[indexPath.section].snipeList[indexPath.row].selected) {
                //選択中
                cell!.backgroundColor = .clearGreen
                cell?.textLabel?.backgroundColor = .clear
            } else {
                //未選択
                cell!.backgroundColor = .clear
            }
            return cell!

        }
    }

    func reloadTableView() {
        tableView.reloadData()
    }
    //タップした時の処理
    //タップした船はレースに出場し色付けされる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if RaceInformation[0].state == "no"{
            try! realm.write {
                if boatType {
                    if (AllUniv[indexPath.section].fourList[indexPath.row].selected) {
                        //未選択へ
                        AllUniv[indexPath.section].fourList[indexPath.row].selected = false
                    }else {
                        //選択へ
                        AllUniv[indexPath.section].fourList[indexPath.row].selected = true
                    }
                } else {
                    if (AllUniv[indexPath.section].snipeList[indexPath.row].selected) {
                        //未選択へ
                        AllUniv[indexPath.section].snipeList[indexPath.row].selected = false
                    }else {
                        //選択へ
                        AllUniv[indexPath.section].snipeList[indexPath.row].selected = true
                    }
                }
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }else {
            let alert = UIAlertController(title: "Stop", message: "レース中に船の変更はできません", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    //セルを編集できるかどうか
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if RaceInformation[0].state == "no" {
            return true
        }else {
            return false
        }
    }
    
    //左スワイプした時の処理
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //削除ボタン
        let delete = UIContextualAction(style: .normal, title: "削除", handler: {(action, sourceView, complicationHandler) in
            complicationHandler(true)
            let alert = UIAlertController(title: "削除", message: "本当に削除してよろしいですか？", preferredStyle: .alert)
            let delete = UIAlertAction(title: "削除", style: .destructive, handler: { (actions) in
                //削除の設定
                if self.boatType {
                    let deleteData = self.AllUniv[indexPath.section].fourList[indexPath.row]
                    try! self.realm.write {
                        self.realm.delete(deleteData)
                    }
                } else {
                    let deleteData = self.AllUniv[indexPath.section].snipeList[indexPath.row]
                    try! self.realm.write {
                        self.realm.delete(deleteData)
                    }
                }
                //セルのリロード
                tableView.deleteRows(at: [indexPath], with: .left)
            })
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            
        })
        //編集ボタン
        let edit = UIContextualAction(style: .normal, title: "編集") { (action, sourceView, complicationHandler) in
            complicationHandler(true)
            //編集の設定
            let boat:boat!
            //削除の設定
            if self.boatType {
                boat = self.AllUniv[indexPath.section].fourList[indexPath.row]
            } else {
                boat = self.AllUniv[indexPath.section].snipeList[indexPath.row]
            }
            self.performSegue(withIdentifier: "toDecide", sender: boat)
            
        }
        edit.backgroundColor = .lightGray
        delete.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [delete,edit])
    }
    
    //画面遷移する前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDecide" {
            //delegateの設定
            let decideViewController = segue.destination as! DecideViewController
            decideViewController.tableViewControllerDelegate = self
            decideViewController.state = "update"
            decideViewController.updateBoat = sender as? boat
        }
    }

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
