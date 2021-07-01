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
                for document in querySnapshot!.documents {
                    let id = document.get("id") as! String
                    let name = document.get("name") as! String
                    let description = document.get("description") as! String
                    let cost = document.get("cost") as! String
                    guard let image = document.get("image") as? String,
                          let imageUrl = URL(string: image) else {
                        return
                    }
                    URLSession.shared.dataTask(with: imageUrl) { data, _, err in
                        guard let data = data, err == nil else {
                            return
                        }
                        let theImage = UIImage(data: data)
                        let product = Product(id: id, name: name, description: description, cost: cost, image: theImage!)
                        products.append(product)
                        if(products.count == querySnapshot?.count){
                            RunLoop.main.perform {
                                callback(products)
                            }
                        }
                    }.resume()
                }
            }
        }
    }
    
    func getAllProductsByOwnerId(_ id:String, _ callback:@escaping (([Product]) -> Void)) {
        var products = [Product]()
        db.collection("products").whereField("owner", isEqualTo: id).getDocuments { querySnapshot, error in
            if(error == nil){
                for document in querySnapshot!.documents {
                    let id = document.get("id") as! String
                    let name = document.get("name") as! String
                    let description = document.get("description") as! String
                    let cost = document.get("cost") as! String
                    guard let image = document.get("image") as? String,
                          let imageUrl = URL(string: image) else {
                        return
                    }
                    URLSession.shared.dataTask(with: imageUrl) { data, _, err in
                        guard let data = data, err == nil else {
                            return
                        }
                        let theImage = UIImage(data: data)
                        let product = Product(id: id, name: name, description: description, cost: cost, image: theImage!)
                        products.append(product)
                        if(products.count == querySnapshot?.count){
                            RunLoop.main.perform {
                                callback(products)
                            }
                        }
                    }.resume()
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
    
}
