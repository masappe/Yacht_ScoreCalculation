//
//  DecideViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/29.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class DecideViewController: UIViewController,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    var updateBoat: boat!
    var registerBoat = boat()
    @IBOutlet weak var boatNumber: UITextField!
    @IBOutlet weak var skipper: UITextField!
    @IBOutlet weak var crew: UITextField!
    var boatKind:[String] = []
    var tempUniv:String = alluniv.shared.univList[0].univ
    var tempBoat:String = "470"
    //add:船の追加，update:船の更新
    var state = ""
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var univTextField: UITextField!
    var univPickerView = UIPickerView()
    @IBOutlet weak var boatTypeTextField: UITextField!
    var boatTypePickerView = UIPickerView()
    var tableViewControllerDelegate: TableViewControllerDelegate!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boatNumber.delegate = self
        skipper.delegate = self
        crew.delegate = self
        
        boatNumber.keyboardType = .numberPad
        boatNumber.placeholder = "入力してください"

        if state == "add" {
            univTextField.placeholder = "選択してください"
            boatTypeTextField.placeholder = "選択してください"
            //textFieldにpickerViewを付け加える
            univPickerView.delegate = self
            univPickerView.dataSource = self
            univPickerView.showsSelectionIndicator = true
            boatTypePickerView.delegate = self
            boatTypePickerView.dataSource = self
            boatTypePickerView.showsSelectionIndicator = true
            
            let toolbar = UIToolbar()
            toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
            let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
            toolbar.setItems([doneItem], animated: true)
            
            univTextField.inputView = univPickerView
            univTextField.inputAccessoryView = toolbar
            boatTypeTextField.inputView = boatTypePickerView
            boatTypeTextField.inputAccessoryView = toolbar

            boatKind.append("470")
            boatKind.append("スナイプ")
            button.setTitle("登録する", for: .normal)
        }
        
        if state == "update" {
            univTextField.text = updateBoat.univ
            //編集できないようにする
            univTextField.isEnabled = false
            boatTypeTextField.isEnabled = false
            if updateBoat.boatType {
                boatTypeTextField.text = "470"
            }else {
                boatTypeTextField.text = "スナイプ"
            }

            button.setTitle("更新する", for: .normal)
            boatNumber.text = String(updateBoat.boatNumber)
            skipper.text = updateBoat.skipper
            crew.text = updateBoat.crew
        }

        
    }

    //pickerviewを閉じる
    @objc func done() {
        univTextField.endEditing(true)
        boatTypeTextField.endEditing(true)
    }
    
    //列の個数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //データ数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if state == "add" {
            if pickerView == univPickerView {
                return alluniv.shared.univList.count
            }else {
                return 2
            }
        }
        return 1
    }
    //データの表示
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if state == "add" {
            if pickerView == univPickerView {
                return alluniv.shared.univList[row].univ
            } else {
                return boatKind[row]
            }
        }
        return nil
    }
    //データが選択された時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if state == "add" {
            if pickerView == univPickerView {
                tempUniv = alluniv.shared.univList[row].univ
                univTextField.text = tempUniv
            } else {
                tempBoat = boatKind[row]
                boatTypeTextField.text = tempBoat
            }
        }
    }
    
    //登録ボタン
    @IBAction func registerButton(_ sender: Any) {
        if state == "add" {
            //登録できるかどうかの条件分岐
            //艇番，大学名，船の種類は必須
            if boatNumber.text == "" || univTextField.text == "" || boatTypeTextField.text == "" {
                let alert = UIAlertController(title: "エラー", message: "艇番，大学名，艇種は入力してください", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(ok)
                present(alert, animated: true, completion: nil)
            }else {
                registerBoat.insert(first: Int(boatNumber.text!)!, second: skipper.text!, thrid: crew.text!,fourth: tempUniv,fifth: tempBoat)
                registerBoat.selected = false
                //大学に艇情報の保存
                for i in 0..<alluniv.shared.univList.count{
                    if tempUniv == alluniv.shared.univList[i].univ{
                        //艇種わけ
                        if tempBoat == "470" {
                            alluniv.shared.univList[i].fourList.append(registerBoat)
                        } else {
                            alluniv.shared.univList[i].snipeList.append(registerBoat)
                        }
                        break
                    }
                }
                self.dismiss(animated: true, completion: {
                    //tableViewのreload
                    self.tableViewControllerDelegate.reloadTableView()
                })

            }
        } else if state == "update" {
            updateBoat.boatNumber = Int(boatNumber.text!)!
            updateBoat.skipper = skipper.text!
            updateBoat.crew = crew.text!
            self.dismiss(animated: true, completion: {
                //tableViewのreload
                self.tableViewControllerDelegate.reloadTableView()
            })

        }
    }
    
    //前に戻る
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
