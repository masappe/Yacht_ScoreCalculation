//
//  DecideViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/29.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class DecideViewController: UIViewController,UITextFieldDelegate {
    var registerBoat = boat()
    @IBOutlet weak var boatNumber: UITextField!
    @IBOutlet weak var skipper: UITextField!
    @IBOutlet weak var crew: UITextField!
    @IBOutlet weak var boatNumberTextField: UITextField!
    @IBOutlet weak var skipperTextField: UITextField!
    @IBOutlet weak var crewTextField: UITextField!
    
    var tableViewControllerDelegate: TableViewControllerDelegate!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boatNumberTextField.delegate = self
        skipperTextField.delegate = self
        crewTextField.delegate = self
        
        boatNumberTextField.keyboardType = .numberPad

        // Do any additional setup after loading the view.
    }
    
    //登録ボタン
    @IBAction func registerButton(_ sender: Any) {
        registerBoat.insert(first: Int(boatNumber.text!)!, second: skipper.text!, thrid: crew.text!,fourth: "")
        registerBoat.selected = false
        snipe.shared.list.append(registerBoat)
        self.dismiss(animated: true, completion: {
            //tableViewのreload
            self.tableViewControllerDelegate.reloadTableView()
        })
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
