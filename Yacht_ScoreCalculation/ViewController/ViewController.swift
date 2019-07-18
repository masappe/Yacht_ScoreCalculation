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
            registerBoat.insert(first: Int(i), second: "", thrid: "",fourth: "名工")
            registerBoat.selected = false
            snipe.shared.list.append(registerBoat)
            for j in 0..<alluniv.shared.univList.count {
                if registerBoat.univ == alluniv.shared.univList[j].univ{
                    alluniv.shared.univList[j].list.append(registerBoat)
                }
            }
        }
        for i in 3...6 {
            let registerBoat = boat()
            registerBoat.insert(first: Int(i), second: "", thrid: "",fourth: "三重")
            registerBoat.selected = false
            snipe.shared.list.append(registerBoat)
            for j in 0..<alluniv.shared.univList.count {
                if registerBoat.univ == alluniv.shared.univList[j].univ{
                    alluniv.shared.univList[j].list.append(registerBoat)
                }
            }
        }
        for i in 7...9 {
            let registerBoat = boat()
            registerBoat.insert(first: Int(i), second: "", thrid: "",fourth: "名城")
            registerBoat.selected = false
            snipe.shared.list.append(registerBoat)
            for j in 0..<alluniv.shared.univList.count {
                if registerBoat.univ == alluniv.shared.univList[j].univ{
                    alluniv.shared.univList[j].list.append(registerBoat)
                }
            }
        }

    }


}

