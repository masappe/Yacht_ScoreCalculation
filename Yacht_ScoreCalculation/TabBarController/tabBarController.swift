//
//  tabBarController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/07/15.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit
import RealmSwift

class tabBarController: UITabBarController,UITabBarControllerDelegate {

    //realm
    let realm = try! Realm()
    var Group: Results<group>!
    var Personal: Results<personal>!
    var RaceInformation: Results<raceInformation>!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        //realm
        Group = realm.objects(group.self)
        Personal = realm.objects(personal.self)
        RaceInformation = realm.objects(raceInformation.self)

        //最初の画面をどこにするか
        if RaceInformation[0].raceCount == 1 {
            selectedIndex = 3
            let settingViewController = selectedViewController as! SettingViewController
            //設定が変更されていたらその設定を反映させる
            if RaceInformation[0].cutRaceNumber != 0 {
                settingViewController.cutTextField.text = String(RaceInformation[0].cutRaceNumber)
                settingViewController.raceNameTextField.text = RaceInformation[0].raceName
                settingViewController.startTextField.text = RaceInformation[0].startRace
                settingViewController.endTextField.text = RaceInformation[0].endRace
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
            try! realm.write {
                if RaceInformation[0].raceCount >= RaceInformation[0].cutRaceNumber {
                    //普通の順位の反映のため
                    raceResult()
                    cutRaceResult()
                    viewController.state = false
                    viewController.titleLabel.title = "\(RaceInformation[0].raceCount)レースまでの結果(cut有り)"
                } else {
                    //cut順位の反映のため
                    cutRaceResult()
                    raceResult()
                    viewController.state = true
                    viewController.titleLabel.title = "\(RaceInformation[0].raceCount)レースまでの結果"
                }
            }
            viewController.tableView.reloadData()
        case is GroupRaceResultViewController:
            let viewController = viewController as! GroupRaceResultViewController
            try! realm.write {
                groupRaceResult()
            }
            viewController.titleLabel.title = "\(RaceInformation[0].raceCount)レースまでの結果"
            viewController.tableView.reloadData()
        case is SettingViewController:
            let settingViewController = viewController as! SettingViewController
            //設定が変更されていたらその設定を反映させる
            if RaceInformation[0].cutRaceNumber != 0 {
                settingViewController.cutTextField.text = String(RaceInformation[0].cutRaceNumber)
                settingViewController.raceNameTextField.text = RaceInformation[0].raceName
                settingViewController.startTextField.text = RaceInformation[0].startRace
                settingViewController.endTextField.text = RaceInformation[0].endRace
            }
        default:
            break
        }
    }
    
    //団体の順位のソート
//    //cutレースの時の順位の計算
//    func groupCutRaceResult(){
//        Group[0].raceList.sort{ $0.cutPoint < $1.cutPoint }
//        for i in 0..<Group[0].raceList.count {
//            Group[0].raceList[i].cutResult = i + 1
//        }
//    }
    //cutレースがない時の順位の計算
    func groupRaceResult(){
        Group[0].raceList.sort{$0.totalPoint < $1.totalPoint}
        for i in 0..<Group[0].raceList.count {
            Group[0].raceList[i].result = i + 1
        }
    }

    //レース順位のソート
    //cutレースの時の順位の計算
    func cutRaceResult() {
        Personal[0].raceList.sort{ $0.cutPoint < $1.cutPoint }
        for i in 0..<Personal[0].raceList.count {
            Personal[0].raceList[i].cutResult = i + 1
        }
    }
    //cutレースがない時の順位の計算
    func raceResult() {
        Personal[0].raceList.sort{$0.totalPoint < $1.totalPoint}
        for i in 0..<Personal[0].raceList.count {
            Personal[0].raceList[i].result = i + 1
        }
    }


}
