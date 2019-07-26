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
    //フィニッシュ前と後に使用
    class var clearGreen:UIColor {
        return UIColor(red: 124/255, green: 252/255, blue: 0, alpha: 0.4)
    }
    
}
