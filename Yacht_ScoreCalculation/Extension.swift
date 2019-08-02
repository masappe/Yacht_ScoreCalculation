//
//  Extension.swift
//  Yacht_ScoreCalculation
//
//  Created by Masato Hayakawa on 2019/07/26.
//  Copyright © 2019 masappe. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    //フィニッシュ前と後，レースに出場するひ船の選択に使用
    class var clearGreen:UIColor {
        return UIColor(red: 124/255, green: 252/255, blue: 0, alpha: 0.4)
    }
    class var clearBlue:UIColor {
        return UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 0.4)
    }
    class var clearRed:UIColor {
        return UIColor(red: 250/255, green: 160/255, blue: 122/255, alpha: 0.4)
    }
    class var backgroundBlue:UIColor {
        return UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 0.2)

    }
    class var backgroundRed:UIColor {
        return UIColor(red: 250/255, green: 160/255, blue: 122/255, alpha: 0.2)
    }
    class var backgroundGreen:UIColor {
        return UIColor(red: 124/255, green: 252/255, blue: 0, alpha: 0.2)
    }

}
class BlueUIButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.blue.cgColor
        tintColor = .black
        backgroundColor = .backgroundBlue
    }
}
class RedUIButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.red.cgColor
        tintColor = .black
        backgroundColor = .backgroundRed
    }
}
class GreenUIButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.green.cgColor
        tintColor = .black
        backgroundColor = .backgroundGreen
    }
}
//TextField
class CustomUITextField: UITextField {
    
    // コピーとペーストを禁止にする
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    //カーソルの非表示
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }

}

//日付用のクラス
class DatePickerKeyboard: UITextField {
    private var datePicker: UIDatePicker!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commoninit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commoninit()
    }
    private func commoninit() {
        // datePickerの設定
        datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ja")
        datePicker.addTarget(self, action: #selector(setText), for: .valueChanged)
        
        // textFieldのtextに日付を表示する
        setText()
        
        inputView = datePicker
        inputAccessoryView = createToolbar()
    }
    
    // キーボードのアクセサリービューを作成する
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 44)
        
        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        space.width = 12
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let todayButtonItem = UIBarButtonItem(title: "今日", style: .done, target: self, action: #selector(todayPicker))
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        
        let toolbarItems = [flexSpaceItem, todayButtonItem, doneButtonItem, space]
        
        toolbar.setItems(toolbarItems, animated: true)
        
        return toolbar
    }
    
    // キーボードの完了ボタンタップ時に呼ばれる
    @objc private func donePicker() {
        resignFirstResponder()
    }
    // キーボードの今日ボタンタップ時に呼ばれる
    @objc private func todayPicker() {
        datePicker.date = Date()
        setText()
    }
    
    // datePickerの日付けをtextFieldのtextに反映させる
    @objc private func setText() {
        let f = DateFormatter()
        f.dateStyle = .long
        f.locale = Locale(identifier: "ja")
        text = f.string(from: datePicker.date)
    }
    
    // クラス外から日付を取り出すためのメソッド
    func getDate() -> Date {
        return datePicker.date
    }
    
    // コピペ等禁止
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
//    // 選択禁止
//    override func selectionRects(for range: UITextRange) -> [Any] {
//        return []
//    }
    // カーソル非表示
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect(x: 0, y: 0, width: 0, height: 0)
    }
}

