//
//  EmptyTableViewUtil.swift
//  TradeMe
//
//  Created by user196691 on 7/9/21.
//

import Foundation
import UIKit

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
            messageLabel.text = message
            messageLabel.textColor = .systemGreen
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = UIFont(name: "TrebuchetMS", size: 25)
            messageLabel.sizeToFit()

            self.backgroundView = messageLabel
        }

    func restore() {
        self.backgroundView = nil
    }
}
