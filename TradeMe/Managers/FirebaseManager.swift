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
    
    func getAllProductsByOwnerId(_ id:String, _ callback:@escaping (([Product]) -> Void)) {
        var products = [Product]()
        print(id)
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
                    let product = Product(id: id, name: name, description: description, cost: cost)
                    products.append(product)
                    print(products.count)
                }
                print(products.count)
                callback(products)
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
