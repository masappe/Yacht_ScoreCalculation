//
//  UniversalViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/07/19.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class UniversalViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var univTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        univTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addUniv(_ sender: Any) {
        let newUniv = universal()
        newUniv.univ = univTextField.text
        alluniv.shared.univList.append(newUniv)
        tableView.reloadData()
        univTextField.text = ""
    }
    
    
    //tableviewに関する操作
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alluniv.shared.univList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = alluniv.shared.univList[indexPath.row].univ
        return cell!
    }
    
    //左スワイプの設定
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //削除ボタン
        let delete = UIContextualAction(style: .destructive, title: "削除", handler: {(action, sourceView, complicationHandler) in
            complicationHandler(true)
            //削除の設定
            alluniv.shared.univList.remove(at: indexPath.row)
            //セルのリロード
            tableView.deleteRows(at: [indexPath], with: .right)
            
        })
        //編集ボタン
        let edit = UIContextualAction(style: .normal, title: "編集") { (action, sourceView, complicationHandler) in
            complicationHandler(true)
            //編集の設定
        }
        
        return UISwipeActionsConfiguration(actions: [delete,edit])
    }


    //前画面に戻る
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
