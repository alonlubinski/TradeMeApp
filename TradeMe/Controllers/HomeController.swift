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
            self.allProducts = products
            self.home_TBV.reloadData()
        }
    }
    
    // Function that shows offer popup dialog
    func showOfferPopupDialog(_ productId: String, _ productName: String, _ ownerId: String) {
        let offerDialog = UIAlertController(title: "Exchange Offer", message: "Send an offer...", preferredStyle: .alert)
        var messageIsNotEmpty = false
        var paymentIsNotEmpty = false
        let sendAction = UIAlertAction(title: "Send", style: .default) { UIAlertAction in
            let userId = Auth.auth().currentUser?.email
            let message = offerDialog.textFields![0].text
            let payment = offerDialog.textFields![1].text
            self.firebaseManager.sendExchangeOffer(userId!, ownerId, productId, productName, message!, payment!)
            self.dismiss(animated: true, completion: nil)
        }
        sendAction.isEnabled = false
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        offerDialog.addAction(sendAction)
        offerDialog.addAction(cancelAction)
        offerDialog.addTextField { textfield in
            textfield.placeholder = "Write message to the owner..."
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textfield, queue: OperationQueue.main) { _ in
                            let textCounter = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                            messageIsNotEmpty = textCounter > 0
                            sendAction.isEnabled = messageIsNotEmpty && paymentIsNotEmpty
                        }
        }
        offerDialog.addTextField { textfield in
            textfield.placeholder = "Fill your payment..."
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textfield, queue: OperationQueue.main) { _ in
                let textCounter = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                paymentIsNotEmpty = textCounter > 0
                sendAction.isEnabled = messageIsNotEmpty && paymentIsNotEmpty
            }
        }
        present(offerDialog, animated: true, completion: nil)
    }
    
    // Function that shows owner's info dialog
    func showSeeOwnerDialog(_ name: String, _ email: String, _ rating: String, _ numOfRates: String) {
        let seeOwnerDialog = UIAlertController(title: name, message: "\(email)\nRating (num of rates): \(rating) (\(numOfRates))", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                self.dismiss(animated: true, completion: nil)
        }
        seeOwnerDialog.addAction(okAction)
        present(seeOwnerDialog, animated: true, completion: nil)
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
        if allProducts.count == 0 {
            tableView.setEmptyMessage("No products to display")
        } else {
            tableView.restore()
        }
        return allProducts.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllProductsTableViewCell.identifier, for: indexPath) as! AllProductsTableViewCell
        let product = allProducts[indexPath.section]
        cell.configure(productId: product.productId, ownerId: product.ownerId, title: product.name, description: product.description, cost: product.cost, image: product.image, date: product.date)
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
    
    func seeOwnerTapped(id: String) {
        print(id)
        firebaseManager.getUserDetailsByUserId(id) { fullName, rating, numOfRates in
            self.showSeeOwnerDialog(fullName, id, rating, numOfRates)
        }
    }
    
    func offerTapped(productId: String, productName: String, ownerId: String) {
        print(productId)
        self.showOfferPopupDialog(productId, productName, ownerId)
    }
}
