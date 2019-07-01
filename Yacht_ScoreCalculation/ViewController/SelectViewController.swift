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

        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snipe.shared.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = snipe.shared.list[indexPath.row].boatNumber
        //選択したのセルのみに色付け
        if (snipe.shared.list[indexPath.row].selected)! {
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
        if (snipe.shared.list[indexPath.row].selected)! {
            //未選択へ
            snipe.shared.list[indexPath.row].selected = false
            for i in 0..<raceInformation.shared.raceList.count {
                if snipe.shared.list[indexPath.row] == raceInformation.shared.raceList[i] {
                    raceInformation.shared.raceList.remove(at: i)
                    raceInformation.shared.cutResultList.remove(at: i)
                    break
                }
            }
        }else {
            //選択へ
            snipe.shared.list[indexPath.row].selected = true
            raceInformation.shared.raceList.append(snipe.shared.list[indexPath.row])
            raceInformation.shared.cutResultList.append(snipe.shared.list[indexPath.row])
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    //画面遷移する前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDecide" {
            let decideViewController = segue.destination as! DecideViewController
            decideViewController.tableViewControllerDelegate = self
        }
    }



}
