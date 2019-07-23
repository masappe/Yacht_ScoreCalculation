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
    @IBOutlet weak var univ: UIPickerView!
    @IBOutlet weak var boatType: UIPickerView!
    var boatKind:[String] = []
    var tempUniv:String = alluniv.shared.univList[0].univ
    var tempBoat:String = "470"
    //add:船の追加，update:船の更新
    var state = ""
    @IBOutlet weak var button: UIButton!
    
    var tableViewControllerDelegate: TableViewControllerDelegate!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boatNumber.delegate = self
        skipper.delegate = self
        crew.delegate = self
        univ.delegate = self
        univ.dataSource = self
        boatType.delegate = self
        boatType.dataSource = self
        
        boatNumber.keyboardType = .numberPad
        
        if state == "add" {
            boatKind.append("470")
            boatKind.append("スナイプ")
            button.setTitle("登録する", for: .normal)
        }
        
        if state == "update" {
            button.setTitle("更新する", for: .normal)
            boatNumber.text = String(updateBoat.boatNumber)
            skipper.text = updateBoat.skipper
            crew.text = updateBoat.crew
        }

        
    }
    
    //列の個数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //データ数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if state == "add" {
            if pickerView == univ {
                return alluniv.shared.univList.count
            }else {
                return 2
            }
        }else {
            return 1
        }
    }
    //データの表示
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if state == "add" {
            if pickerView == univ {
                return alluniv.shared.univList[row].univ
            } else {
                return boatKind[row]
            }
        } else {
            if pickerView == univ {
                return updateBoat.univ
            } else {
                if updateBoat.boatType {
                    return "470"
                } else {
                    return "スナイプ"
                }
            }
        }
    }
    //データが選択された時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if state == "add" {
            if pickerView == univ {
                tempUniv = alluniv.shared.univList[row].univ
            } else {
                tempBoat = boatKind[row]
            }
        }
    }
    
    //登録ボタン
    @IBAction func registerButton(_ sender: Any) {
        if state == "add" {
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
