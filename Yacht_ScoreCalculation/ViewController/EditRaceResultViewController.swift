



//
//  EditRaceResultViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/07/24.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class EditRaceResultViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var boatNumberLabel: UILabel!
    @IBOutlet weak var raceNumberLabel: UILabel!
    @IBOutlet weak var editTextField: UITextField!
    var boat: boat!
    var boatNum: Int!
    //raceNum+1レース目
    var raceNum: Int!
    var tableViewControllerDelegate:PersonalTableViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTextField.delegate = self
        editTextField.keyboardType = .numberPad

        boat = personal.shared.raceList[boatNum]
        boatNumberLabel.text = "艇番:\(String(boat.boatNumber))"
        raceNumberLabel.text = "第\(String(raceNum+1))レース目"
        editTextField.text = String(boat.racePoint[raceNum])
        
        
    }
    
    //更新ボタン
    @IBAction func updateButton(_ sender: Any) {
        if editTextField.text! == "" {
            let alert = UIAlertController(title: "エラー", message: "値を入力してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }else {
            let point = Int(editTextField.text!)
            //船の点数の更新
            boat.racePoint[raceNum] = point!
            //合計点の更新
            boat.calculateRacePoint()
            //大学のレースの合計点を更新
            for i in 0..<group.shared.raceList.count {
                var sum = 0
                if boat.univ == group.shared.raceList[i].univ {
                    for j in 0..<group.shared.raceList[i].boat.count {
                        sum = sum + group.shared.raceList[i].boat[j].racePoint[raceNum]
                    }
                    group.shared.raceList[i].racePoint[raceNum] = sum
                    //total.badpointの計算
                    group.shared.raceList[i].calculateRacePoint()
                    break
                }
            }
            
            
            
            let alert = UIAlertController(title: "更新", message: "更新完了しました", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true) {
            self.tableViewControllerDelegate.reloadTableView()
        }
        
    }
    
    //キーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}
