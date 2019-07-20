//
//  ViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/29.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //テストデータで使用中
        let meikou = universal()
        meikou.univ = "名工"
        let mie = universal()
        mie.univ = "三重"
        let meizyou = universal()
        meizyou.univ = "名城"
        alluniv.shared.univList.append(meikou)
        alluniv.shared.univList.append(mie)
        alluniv.shared.univList.append(meizyou)

        for i in 0...2 {
            let registerBoat = boat()
            registerBoat.insert(first: Int(i), second: "", thrid: "",fourth: "名工",fifth: "スナイプ")
            registerBoat.selected = false
            snipe.shared.list.append(registerBoat)
            for j in 0..<alluniv.shared.univList.count {
                if registerBoat.univ == alluniv.shared.univList[j].univ{
                    alluniv.shared.univList[j].snipeList.append(registerBoat)
                }
            }
        }
        for i in 3...6 {
            let registerBoat = boat()
            registerBoat.insert(first: Int(i), second: "", thrid: "",fourth: "三重",fifth: "スナイプ")
            registerBoat.selected = false
            snipe.shared.list.append(registerBoat)
            for j in 0..<alluniv.shared.univList.count {
                if registerBoat.univ == alluniv.shared.univList[j].univ{
                    alluniv.shared.univList[j].snipeList.append(registerBoat)
                }
            }
        }
        for i in 7...9 {
            let registerBoat = boat()
            registerBoat.insert(first: Int(i), second: "", thrid: "",fourth: "名城",fifth: "スナイプ")
            registerBoat.selected = false
            snipe.shared.list.append(registerBoat)
            for j in 0..<alluniv.shared.univList.count {
                if registerBoat.univ == alluniv.shared.univList[j].univ{
                    alluniv.shared.univList[j].snipeList.append(registerBoat)
                }
            }
        }

    }
    
    @IBAction func selectFour(_ sender: Any) {
        performSegue(withIdentifier: "toSelect", sender: true)
    }
    
    @IBAction func selectSnipe(_ sender: Any) {
        performSegue(withIdentifier: "toSelect", sender: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelect" {
            let viewController = segue.destination as! SelectViewController
            viewController.boatType = sender as! Bool
        }
    }
    
}

