//
//  ExchangeOffer.swift
//  TradeMe
//
//  Created by user196691 on 7/3/21.
//

import Foundation

class ExchangeOffer {
    
    var offerId: String
    var userId: String
    var ownerId: String
    var productId: String
    var productName: String
    var message: String
    var payment: String
    var date: String
    var dateInterval: TimeInterval
    
    init(offerId: String, userId: String, ownerId: String, productId: String, productName: String, message: String, payment: String, date: String, dateInterval: TimeInterval){
        self.offerId = offerId
        self.userId = userId
        self.ownerId = ownerId
        self.productId = productId
        self.productName = productName
        self.message = message
        self.payment = payment
        self.date = date
        self.dateInterval = dateInterval
    }
}
