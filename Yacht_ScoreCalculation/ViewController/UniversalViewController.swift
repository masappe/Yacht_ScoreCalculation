//
//  UniversalViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/07/19.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit
import RealmSwift

class UniversalViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var univTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    //realm
    let realm = try! Realm()
    var AllUniv: Results<universal>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        univTextField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self

        //relamデータの取り出し
        AllUniv = realm.objects(universal.self)

        // Do any additional setup after loading the view.
    }
    
    //大学の追加
    @IBAction func addUniv(_ sender: Any) {
        if univTextField.text == "" {
            let alerm = UIAlertController(title: "エラー", message: "大学名を記入してください", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alerm.addAction(ok)
            present(alerm, animated: true, completion: nil)
        }else{
            let newUniv = universal()
            newUniv.univ = univTextField.text
            try! realm.write {
                realm.add(newUniv)
            }
            //        alluniv.shared.univList.append(newUniv)
            tableView.reloadData()
            univTextField.text = ""
        }
    }
    
    
    //tableviewに関する操作
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllUniv.count
//        return alluniv.shared.univList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = AllUniv[indexPath.row].univ
//        cell?.textLabel?.text = alluniv.shared.univList[indexPath.row].univ
        return cell!
    }
    
    //左スワイプの設定
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //削除ボタン
        let delete = UIContextualAction(style: .normal, title: "削除", handler: {(action, sourceView, complicationHandler) in
            complicationHandler(true)
            let alert = UIAlertController(title: "削除", message: "本当に削除してよろしいですか？", preferredStyle: .alert)
            let delete = UIAlertAction(title: "削除", style: .destructive, handler: { (action) in
                //削除するデータの選択
                let deleteData = self.AllUniv[indexPath.row]
                //削除の設定
                try! self.realm.write {
                    self.realm.delete(deleteData)
                }
//                alluniv.shared.univList.remove(at: indexPath.row)
                //セルのリロード
                tableView.deleteRows(at: [indexPath], with: .left)
            })
            let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        })
        delete.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    //タップし終わったら色が消える
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
