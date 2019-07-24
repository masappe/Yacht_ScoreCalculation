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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cutTextField.delegate = self
        cutTextField.keyboardType = .numberPad
        
        cutTextField.text = String(raceInformation.shared.cutRaceNumber)

    }
    
    @IBAction func updateButton(_ sender: Any) {
        //カットレース情報の更新
        if cutTextField.text != "" {
            let temp = cutTextField.text
            raceInformation.shared.cutRaceNumber = Int(temp!)!
        }
        let alert = UIAlertController(title: "更新", message: " カットレースを更新しました", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
        
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