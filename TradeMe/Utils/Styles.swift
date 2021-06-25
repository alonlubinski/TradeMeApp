//
//  Styles.swift
//  TradeMe
//
//  Created by user196684 on 6/10/21.
//

import Foundation
import UIKit

class Styles {
        static func textField(_ textfield:UITextField) {
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
            bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
            textfield.borderStyle = .none
            textfield.layer.addSublayer(bottomLine)
            
        }
        
        static func filledButton(_ button:UIButton) {
            button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
            button.layer.cornerRadius = 25.0
            button.tintColor = UIColor.white
        }
        
        static func transparentButton(_ button:UIButton) {
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = 25.0
            button.tintColor = UIColor.black
        }
}
