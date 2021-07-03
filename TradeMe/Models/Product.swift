//
//  Product.swift
//  TradeMe
//
//  Created by user196691 on 6/30/21.
//

import Foundation
import UIKit

class Product {
    var productId: String
    var ownerId: String
    var name: String
    var description: String
    var cost: String
    var image: UIImage
    var date: String
    var dateInterval: TimeInterval
    
    init(productId: String, ownerId: String, name: String, description: String, cost: String, image: UIImage, date: String, dateInterval: TimeInterval){
        self.productId = productId
        self.ownerId = ownerId
        self.name = name
        self.description = description
        self.cost = cost
        self.image = image
        self.date = date
        self.dateInterval = dateInterval
    }
}
