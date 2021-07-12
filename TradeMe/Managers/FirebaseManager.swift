//
//  FirebaseManager.swift
//  TradeMe
//
//  Created by user196691 on 6/30/21.
//

import Foundation
import Firebase

class FirebaseManager {
    
    let db = Firebase.Firestore.firestore()
    let storage = Firebase.Storage.storage().reference()
    
    func getAllProductsWithoutUserProducts(_ id: String, _ callback:@escaping (([Product]) -> Void)) {
        var products = [Product]()
        db.collection("products").whereField("owner", isNotEqualTo: id).getDocuments { querySnapshot, error in
            if(error == nil){
                if(querySnapshot?.documents.count == 0){
                    callback(products)
                } else {
                    for document in querySnapshot!.documents {
                        let productId = document.get("id") as! String
                        let ownerId = document.get("owner") as! String
                        let name = document.get("name") as! String
                        let description = document.get("description") as! String
                        let cost = document.get("cost") as! String
                        let date = document.get("date") as! String
                        let dateInterval = document.get("dateInterval") as! TimeInterval
                        guard let image = document.get("image") as? String,
                              let imageUrl = URL(string: image) else {
                            return
                        }
                        URLSession.shared.dataTask(with: imageUrl) { data, _, err in
                            guard let data = data, err == nil else {
                                return
                            }
                            let theImage = UIImage(data: data)
                            let product = Product(productId: productId, ownerId: ownerId, name: name, description: description, cost: cost, image: theImage!, date: date, dateInterval: dateInterval)
                            products.append(product)
                            if(products.count == querySnapshot?.count){
                                let sortedProducts = products.sorted(by: {$0.dateInterval > $1.dateInterval})
                                RunLoop.main.perform {
                                    callback(sortedProducts)
                                }
                            }
                        }.resume()
                    }
                }
            }
        }
    }
    
    func getAllProductsByOwnerId(_ id:String, _ callback:@escaping (([Product]) -> Void)) {
        var products = [Product]()
        db.collection("products").whereField("owner", isEqualTo: id).getDocuments { querySnapshot, error in
            if(error == nil){
                if(querySnapshot?.documents.count == 0){
                    callback(products)
                } else {
                    for document in querySnapshot!.documents {
                        let productId = document.get("id") as! String
                        let ownerId = document.get("owner") as! String
                        let name = document.get("name") as! String
                        let description = document.get("description") as! String
                        let cost = document.get("cost") as! String
                        let date = document.get("date") as! String
                        let dateInterval = document.get("dateInterval") as! TimeInterval
                        guard let image = document.get("image") as? String,
                              let imageUrl = URL(string: image) else {
                            return
                        }
                        URLSession.shared.dataTask(with: imageUrl) { data, _, err in
                            guard let data = data, err == nil else {
                                return
                            }
                            let theImage = UIImage(data: data)
                            let product = Product(productId: productId, ownerId: ownerId, name: name, description: description, cost: cost, image: theImage!, date: date, dateInterval: dateInterval)
                            products.append(product)
                            if(products.count == querySnapshot?.count){
                                let sortedProducts = products.sorted(by: {$0.dateInterval > $1.dateInterval})
                                RunLoop.main.perform {
                                    callback(sortedProducts)
                                }
                            }
                        }.resume()
                    }

                }
            }
        }
    }
    
    func downloadImageUrlFromStorageByImageId(_ imageId: String, _ callback:@escaping ((String) -> Void)) {
        var urlString = ""
        urlString = ""
        storage.child("products/\(imageId).png").downloadURL { url, error in
            guard let url = url, error == nil else {
                return
            }
            urlString = url.absoluteString
            callback(urlString)
        }
    }
    
    func deleteProductByProductId(_ productId: String, _ callback:@escaping (() -> Void)) {
        db.collection("products").document(productId).delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                callback()
            }
        }
    }
    
    func getUserDetailsByUserId(_ userId: String, _ callback:@escaping ((String, String, String) -> Void)) {
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                let firstName = document.get("firstName") as! String
                let lastName = document.get("lastName") as! String
                let fullName = "\(firstName) \(lastName)"
                let rating = document.get("rating") as! Double
                let numOfRates = document.get("numOfRates") as! Double
                var calculatedRating = 0.0
                if(numOfRates > 0){
                    calculatedRating = rating / numOfRates
                }
                let calculatedRatingStr: String = String(format: "%.2f", calculatedRating)
                let numOfRatesStr: String = String(format: "%.0f", numOfRates)
                callback(fullName, calculatedRatingStr, numOfRatesStr)
            }
        }
    }
    
    func sendExchangeOffer(_ userId: String, _ ownerId: String, _ productId: String, _ productName: String, _ message: String, _ payment: String) {
        let offerId = UUID().uuidString
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        let dateInterval = NSDate().timeIntervalSince1970
        db.collection("offers").document(offerId).setData(["offerId": offerId,
                                                           "userId": userId,
                                                           "ownerId": ownerId,
                                                           "productId": productId,
                                                           "productName": productName,
                                                           "message": message,
                                                           "payment": payment,
                                                           "date": formattedDate,
                                                           "dateInterval": dateInterval])
    }
    
    func getAllExchangeOffersByUserId(_ id: String, _ callback:@escaping (([ExchangeOffer]) -> Void)) {
        var offers = [ExchangeOffer]()
        db.collection("offers").whereField("ownerId", isEqualTo: id).getDocuments { querySnapshot, error in
            if(error == nil){
                if(querySnapshot?.documents.count == 0){
                    callback(offers)
                } else {
                    for document in querySnapshot!.documents {
                        let offerId = document.get("offerId") as! String
                        let userId = document.get("userId") as! String
                        let ownerId = document.get("ownerId") as! String
                        let productId = document.get("productId") as! String
                        let productName = document.get("productName") as! String
                        let message = document.get("message") as! String
                        let payment = document.get("payment") as! String
                        let date = document.get("date") as! String
                        let dateInterval = document.get("dateInterval") as! TimeInterval
                        let exchangeOffer = ExchangeOffer(offerId: offerId, userId: userId, ownerId: ownerId, productId: productId, productName: productName, message: message, payment: payment, date: date, dateInterval: dateInterval)
                        offers.append(exchangeOffer)
                        if(offers.count == querySnapshot?.count){
                            let sortedOffers = offers.sorted(by: {$0.dateInterval > $1.dateInterval})
                            RunLoop.main.perform {
                                callback(sortedOffers)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func deleteExchangeOfferByExchangeOfferId(_ offerId: String, _ callback:@escaping (() -> Void)){
        db.collection("offers").document(offerId).delete { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                callback()
            }
        }
    }
    
    func getExchangeOffersIdsByProductId(_ productId: String, _ callback:@escaping (([String]) -> Void)){
        var offersIds = [String]()
        db.collection("offers").whereField("productId", isEqualTo: productId).getDocuments { querySnapshot, error in
            if error == nil {
                if(querySnapshot?.documents.count == 0){
                    callback(offersIds)
                } else {
                    for document in querySnapshot!.documents {
                        let documentId = document.get("offerId") as! String
                        offersIds.append(documentId)
                        if(offersIds.count == querySnapshot?.count){
                            callback(offersIds)
                        }
                    }
                }
            }
        }
    }
    
    func deleteExchangeOffersByOfferIds(_ offerIds: [String], _ callback:@escaping (() -> Void)){
        var counter = 0
        print("delete all offer function - num of offers: \(offerIds.count)")
        if(offerIds.count == 0){
            callback()
        } else {
            for offerId in offerIds {
                print("Here with offer: \(offerId)")
                db.collection("offers").document(offerId).delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        counter += 1
                        if(counter == offerIds.count){
                            print("counter is: \(counter)")
                            callback()
                        }
                    }
                }
            }
        }
    }
    
    func addExchange(_ productId: String, _ productName: String, _ ownerId: String, _ userId: String, _ payment: String) {
        let exchangeId = UUID().uuidString
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        let dateInterval = NSDate().timeIntervalSince1970
        db.collection("exchanges").document(exchangeId).setData(["exchangeId": exchangeId,
                                                                 "productId": productId,
                                                                 "productName": productName,
                                                                 "ownerId": ownerId,
                                                                 "userId": userId,
                                                                 "payment": payment,
                                                                 "date": formattedDate,
                                                                 "dateInterval": dateInterval])
    }
    
    func getAllExchangesByUserId(_ userId: String, _ field: String, _ callback:@escaping (([Exchange]) -> Void)){
        var exchanges = [Exchange]()
        db.collection("exchanges").whereField(field, isEqualTo: userId).getDocuments { querySnapshot, error in
            if(error == nil){
                if(querySnapshot?.documents.count == 0){
                    callback(exchanges)
                } else {
                    for document in querySnapshot!.documents{
                        let exchangeId = document.get("exchangeId") as! String
                        let productId = document.get("productId") as! String
                        let productName = document.get("productName") as! String
                        let ownerId = document.get("ownerId") as! String
                        let userId = document.get("userId") as! String
                        let payment = document.get("payment") as! String
                        let date = document.get("date") as! String
                        let dateInterval = document.get("dateInterval") as! TimeInterval
                        let exchange = Exchange(exchangeId: exchangeId, productId: productId, productName: productName, ownerId: ownerId, userId: userId, payment: payment, date: date, dateInterval: dateInterval)
                        exchanges.append(exchange)
                        if(exchanges.count == querySnapshot?.count){
                            callback(exchanges)
                        }
                    }
                }
            }
        }
    }

    func updateRating(_ userId: String, _ rate: Int, _ callback:@escaping (() -> Void)){
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                let rating = document.get("rating") as! Int
                let numOfRates = document.get("numOfRates") as! Int
                let updatedRating = rating + rate
                let updatedNumOfRates = numOfRates + 1
                self.db.collection("users").document(userId).updateData(
                    ["rating" : updatedRating,
                     "numOfRates" : updatedNumOfRates]) { err in
                    if let err = err {
                        print(err.localizedDescription)
                    } else {
                        callback()
                    }
                }
            }
        }
    }
    
}
