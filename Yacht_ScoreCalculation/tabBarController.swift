//
//  tabBarController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/07/15.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class tabBarController: UITabBarController,UITabBarControllerDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        selectedIndex = 0
        // Do any additional setup after loading the view.
    }
    
    //tabbarの選択
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch viewController {
        case is RaceViewController:
            break
        case is RaceResultViewController:
            raceResult()
            let viewController = viewController as! RaceResultViewController
            viewController.tableView.reloadData()
        case is CutRaceResultViewController:
            cutRaceResult()
            let viewController = viewController as! CutRaceResultViewController
            viewController.tableView.reloadData()
        default:
            break
        }
    }
    
    //レース順位のソート
    //cutレースの時の順位の計算
    func cutRaceResult() {
        raceInformation.shared.raceList.sort{ $0.cutPoint < $1.cutPoint }
        for i in 0..<raceInformation.shared.raceList.count {
            raceInformation.shared.raceList[i].cutResult = i + 1
        }
    }
    //cutレースがない時の順位の計算
    func raceResult() {
        raceInformation.shared.raceList.sort{$0.totalPoint < $1.totalPoint}
        for i in 0..<raceInformation.shared.raceList.count {
            raceInformation.shared.raceList[i].result = i + 1
        }
    }


}
