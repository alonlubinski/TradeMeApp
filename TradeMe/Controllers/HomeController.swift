//
//  HomeController.swift
//  TradeMe
//
//  Created by user196691 on 6/25/21.
//

import UIKit
import Firebase

class HomeController: UIViewController {

    let firebaseManager = FirebaseManager()
    var allProducts: [Product] = []
    
    @IBOutlet weak var home_TBV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        home_TBV.register(AllProductsTableViewCell.nib(), forCellReuseIdentifier: AllProductsTableViewCell.identifier)
        home_TBV.delegate = self
        home_TBV.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userId = Firebase.Auth.auth().currentUser?.email
        firebaseManager.getAllProductsWithoutUserProducts(userId!) { products in
            //print(products.count)
            self.allProducts = products
            self.home_TBV.reloadData()
        }
    }
    
    func showOfferPopupDialog() {
        let offerDialog = UIAlertController(title: "Exchange Offer", message: "Make an offer...", preferredStyle: .alert)
        
        present(offerDialog, animated: true, completion: nil)
    }
    
    func showSeeOwnerDialog(_ name: String, _ email: String) {
        let offerDialog = UIAlertController(title: name, message: email, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                self.dismiss(animated: true, completion: nil)
        }
        offerDialog.addAction(okAction)
        present(offerDialog, animated: true, completion: nil)
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

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        allProducts.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllProductsTableViewCell.identifier, for: indexPath) as! AllProductsTableViewCell
        let product = allProducts[indexPath.section]
        cell.configure(productId: product.productId, ownerId: product.ownerId, title: product.name, description: product.description, cost: product.cost, image: product.image)
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

extension HomeController: AllProductsTableViewCellDelegate {
    
    func seeOwnerTapped(with id: String) {
        print(id)
        firebaseManager.getUserDetailsByUserId(id) { fullName in
            self.showSeeOwnerDialog(fullName, id)
        }
    }
    
    func offerTapped(with id: String) {
        print(id)
        
    }
}
