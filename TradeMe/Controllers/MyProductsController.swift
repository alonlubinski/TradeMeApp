//
//  MyProductsController.swift
//  TradeMe
//
//  Created by user196691 on 6/26/21.
//

import UIKit
import Firebase

class MyProductsController: UIViewController {
    
    let firebaseManager = FirebaseManager()
    var myProducts: [Product] = []

    @IBOutlet weak var my_TBV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        my_TBV.register(MyProductTableViewCell.nib(), forCellReuseIdentifier: MyProductTableViewCell.identifier)
        my_TBV.delegate = self
        my_TBV.dataSource = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let ownerId = Firebase.Auth.auth().currentUser?.email
        firebaseManager.getAllProductsByOwnerId(ownerId!) { products in
            //print(products.count)
            self.myProducts = products
            self.my_TBV.reloadData()
        }
    }
    
    func showConfirmationDialog(_ productId: String){
        let acceptDialog = UIAlertController(title: "Delete Product", message: "Are you sure? The product and all the offers for this product will be deleted.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { UIAlertAction in
            guard let arrIndex =  self.myProducts.firstIndex(where: {$0.productId == productId}) else {
                    return
                }
            self.myProducts.remove(at: arrIndex)
            self.firebaseManager.deleteProductByProductId(productId) {
                self.firebaseManager.getExchangeOffersIdsByProductId(productId) { offerIds in
                    self.firebaseManager.deleteExchangeOffersByOfferIds(offerIds) {
                        self.my_TBV.reloadData()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        acceptDialog.addAction(confirmAction)
        acceptDialog.addAction(cancelAction)
        present(acceptDialog, animated: true, completion: nil)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MyProductsController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if myProducts.count == 0 {
            tableView.setEmptyMessage("No products to display")
        } else {
            tableView.restore()
        }
        return myProducts.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyProductTableViewCell.identifier, for: indexPath) as! MyProductTableViewCell
        let product = myProducts[indexPath.section]
        cell.configure(productId: product.productId, title: product.name, description: product.description, cost: product.cost, image: product.image, date: product.date)
        cell.delegate = self
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.white.withAlphaComponent(0)
        return header
    }
}

extension MyProductsController: MyProductTableViewCellDelegate {
    
    func deleteTapped(with id: String) {
        print(id)
        showConfirmationDialog(id)
        
    }


    
}
