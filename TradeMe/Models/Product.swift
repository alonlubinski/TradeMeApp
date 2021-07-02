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
    
    init(productId: String, ownerId: String, name: String, description: String, cost: String, image: UIImage){
        self.productId = productId
        self.ownerId = ownerId
        self.name = name
        self.description = description
        self.cost = cost
        self.image = image
    }
}
