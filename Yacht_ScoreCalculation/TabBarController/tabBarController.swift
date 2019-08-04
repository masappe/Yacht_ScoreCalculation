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
        //最初の画面をどこにするか
        if raceInformation.shared.raceCount == 1 {
            selectedIndex = 3
            let settingViewController = selectedViewController as! SettingViewController
            //設定が変更されていたらその設定を反映させる
            if raceInformation.shared.cutRaceNumber != 0 {
                settingViewController.cutTextField.text = String(raceInformation.shared.cutRaceNumber)
                settingViewController.raceNameTextField.text = raceInformation.shared.raceName
                settingViewController.startTextField.text = raceInformation.shared.startRace
                settingViewController.endTextField.text = raceInformation.shared.endRace
            }
            
        }else {
            selectedIndex = 0
        }
        // Do any additional setup after loading the view.
    }
    
    //tabbarの選択
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch viewController {
        case is RaceViewController:
            break
        case is PersonalRaceResultViewController:
            let viewController = viewController as! PersonalRaceResultViewController
            if raceInformation.shared.raceCount >= raceInformation.shared.cutRaceNumber {
                //普通の順位の反映のため
                raceResult()
                cutRaceResult()
                viewController.state = false
                viewController.titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果(cut有り)"
            } else {
                //cut順位の反映のため
                cutRaceResult()
                raceResult()
                viewController.state = true
                viewController.titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果"
            }
            viewController.tableView.reloadData()
        case is GroupRaceResultViewController:
            let viewController = viewController as! GroupRaceResultViewController
            
//            if raceInformation.shared.raceCount >= raceInformation.shared.cutRaceNumber {
//                //普通の順位の反映のため
//                groupRaceResult()
//                groupCutRaceResult()
//                viewController.state = false
//                viewController.titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果(cut有り)"
//
//            } else {
//                //cut順位の反映のため
//                groupCutRaceResult()
//                groupRaceResult()
//                viewController.state = true
//                viewController.titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果"
//            }
            groupRaceResult()
            viewController.titleLabel.title = "\(raceInformation.shared.raceCount)レースまでの結果"
            viewController.tableView.reloadData()
        case is SettingViewController:
            let settingViewController = viewController as! SettingViewController
            //設定が変更されていたらその設定を反映させる
            if raceInformation.shared.cutRaceNumber != 0 {
                settingViewController.cutTextField.text = String(raceInformation.shared.cutRaceNumber)
                settingViewController.raceNameTextField.text = raceInformation.shared.raceName
                settingViewController.startTextField.text = raceInformation.shared.startRace
                settingViewController.endTextField.text = raceInformation.shared.endRace
            }
        default:
            break
        }
    }
    
    //団体の順位のソート
//    //cutレースの時の順位の計算
//    func groupCutRaceResult(){
//        group.shared.raceList.sort{ $0.cutPoint < $1.cutPoint }
//        for i in 0..<group.shared.raceList.count {
//            group.shared.raceList[i].cutResult = i + 1
//        }
//    }
    //cutレースがない時の順位の計算
    func groupRaceResult(){
        group.shared.raceList.sort{$0.totalPoint < $1.totalPoint}
        for i in 0..<group.shared.raceList.count {
            group.shared.raceList[i].result = i + 1
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
