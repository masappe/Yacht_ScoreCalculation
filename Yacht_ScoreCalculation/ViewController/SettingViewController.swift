//
//  SettingViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/07/20.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var cutTextField: UITextField!
    @IBOutlet weak var raceNameTextField: UITextField!
    @IBOutlet weak var startTextField: DatePickerKeyboard!
    @IBOutlet weak var endTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        raceNameTextField.placeholder = "ex.〇〇大会"
        cutTextField.placeholder = "ex.4"
        
        
        raceNameTextField.delegate = self
        cutTextField.delegate = self
        cutTextField.keyboardType = .numberPad
        

    }
    
    @IBAction func updateButton(_ sender: Any) {
        //情報の更新
        if cutTextField.text != "" && raceNameTextField.text != "" {
            //開始日と終了日
            raceInformation.shared.startRace = startTextField.text!
            raceInformation.shared.endRace = endTextField.text!
            //大会名
            raceInformation.shared.raceName = raceNameTextField.text!
            //カットレース
            let temp = cutTextField.text
            raceInformation.shared.cutRaceNumber = Int(temp!)!
            //レース情報の更新
            let alert = UIAlertController(title: "更新", message: " レース情報を更新しました", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)

        } else {
            //エラー
            let alert = UIAlertController(title: "エラー", message: "全ての情報を記載してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)

            
        }
        
    }
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
