//
//  Exchange.swift
//  TradeMe
//
//  Created by user196691 on 7/4/21.
//

import Foundation

class Exchange {
    
    var exchangeId: String
    var productId: String
    var productName: String
    var ownerId: String
    var userId: String
    var payment: String
    var date: String
    var dateInterval: TimeInterval
    
    init(exchangeId: String, productId: String, productName: String, ownerId: String, userId: String, payment: String, date: String, dateInterval: TimeInterval) {
        self.exchangeId = exchangeId
        self.productId = productId
        self.productName = productName
        self.ownerId = ownerId
        self.userId = userId
        self.payment = payment
        self.date = date
        self.dateInterval = dateInterval
    }
}
