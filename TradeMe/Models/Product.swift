//
//  Product.swift
//  TradeMe
//
//  Created by user196691 on 6/30/21.
//

import Foundation
import UIKit

class Product {
    var id: String
    var name: String
    var description: String
    var cost: String
    //var image: UIImage
    
    init(id: String, name: String, description: String, cost: String){
        self.id = id
        self.name = name
        self.description = description
        self.cost = cost
        //self.image = image
    }
}
