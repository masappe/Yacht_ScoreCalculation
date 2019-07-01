//
//  DecideViewController.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/06/29.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

class DecideViewController: UIViewController {
    var registerBoat = boat()
    @IBOutlet weak var boatNumber: UITextField!
    @IBOutlet weak var skipper: UITextField!
    @IBOutlet weak var crew: UITextField!
    var tableViewControllerDelegate: TableViewControllerDelegate!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButton(_ sender: Any) {
        registerBoat.insert(first: boatNumber.text!, second: skipper.text!, thrid: crew.text!)
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
    
    @IBAction func debugButton(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
