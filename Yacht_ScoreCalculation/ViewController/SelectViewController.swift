//
//  SelectViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/29.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

protocol TableViewControllerDelegate {
    func reloadTableView()
}

class SelectViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TableViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegate,datasource
        tableView.delegate = self
        tableView.dataSource = self

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return alluniv.shared.univList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return alluniv.shared.univList[section].univ
    }

    //tableviewの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return alluniv.shared.univList[section].list.count
    }
    //tableviewに表示するセルの情報
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
//        cell?.textLabel?.text = String(snipe.shared.list[indexPath.row].boatNumber)
        cell?.textLabel?.text = String(alluniv.shared.univList[indexPath.section].list[indexPath.row].boatNumber)
        //選択したのセルのみに色付け
        if (alluniv.shared.univList[indexPath.section].list[indexPath.row].selected)! {
            //選択中
            cell!.backgroundColor = .red
        } else {
            //未選択
            cell!.backgroundColor = .clear
        }
        return cell!
    }

    func reloadTableView() {
        tableView.reloadData()
    }
    //タップした時の処理
    //タップした船はレースに出場し色付けされる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (alluniv.shared.univList[indexPath.section].list[indexPath.row].selected)! {
            //未選択へ
            alluniv.shared.univList[indexPath.section].list[indexPath.row].selected = false
        }else {
            //選択へ
            alluniv.shared.univList[indexPath.section].list[indexPath.row].selected = true
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    //画面遷移する前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDecide" {
            //delegateの設定
            let decideViewController = segue.destination as! DecideViewController
            decideViewController.tableViewControllerDelegate = self
        }
        if segue.identifier == "toRace" {
            //レースに参加する船の反映
            for i in 0..<alluniv.shared.univList.count {
                for j in 0..<alluniv.shared.univList[i].list.count {
                    if alluniv.shared.univList[i].list[j].selected {
                        //個人の追加
                        personal.shared.raceList.append(alluniv.shared.univList[i].list[j])
                    }
                }
            }
            //大学の追加と大学に各船の追加
            for i in 0..<personal.shared.raceList.count {
                if group.shared.raceList.count == 0 {
                    let new = boats()
                    new.univ = personal.shared.raceList[i].univ
                    new.boat.append(personal.shared.raceList[i])
                    group.shared.raceList.append(new)
                }else {
                    var isInsert = false
                    //既存の大学と一致しなかったら追加する
                    hantei:for j in 0..<alluniv.shared.univList.count{
                        if alluniv.shared.univList[j].univ == personal.shared.raceList[i].univ {
                            //レースに出る団体に追加する
                            for k in 0..<group.shared.raceList.count {
                                if group.shared.raceList[k].univ == personal.shared.raceList[i].univ{
                                    group.shared.raceList[k].boat.append(personal.shared.raceList[i])
                                    break hantei
                                }
                            }
                        }
                        //最後まで一致しなかったら
                        if j == alluniv.shared.univList.count-1{
                            isInsert = true
                        }
                    }
                    if isInsert {
                        //一致しなかったら追加する
                        let new = boats()
                        new.univ = personal.shared.raceList[i].univ
                        new.boat.append(personal.shared.raceList[i])
                        group.shared.raceList.append(new)
                    }

                }
            }
            
//            for i in 0..<group.shared.raceList.count{
//                print(group.shared.raceList[i].univ!)
//                for j in 0..<group.shared.raceList[i].boat.count{
//                    print(group.shared.raceList[i].boat[j].boatNumber!)
//                }
//            }

//            //レースに追加する船の反映
//            for i in 0..<snipe.shared.list.count {
//                if snipe.shared.list[i].selected {
//                    personal.shared.raceList.append(snipe.shared.list[i])
//                }
//            }
        }
    }



}
