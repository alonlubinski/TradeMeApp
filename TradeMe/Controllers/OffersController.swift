//
//  OffersController.swift
//  TradeMe
//
//  Created by user196691 on 6/26/21.
//

import UIKit
import Firebase

class OffersController: UIViewController {

    let firebaseManager = FirebaseManager()
    var myOffers: [ExchangeOffer] = []
    
    @IBOutlet weak var offers_TBV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        offers_TBV.register(OffersTableViewCell.nib(), forCellReuseIdentifier: OffersTableViewCell.identifier)
        offers_TBV.delegate = self
        offers_TBV.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let ownerId = Firebase.Auth.auth().currentUser?.email
        firebaseManager.getAllExchangeOffersByUserId(ownerId!) { offers in
            self.myOffers = offers
            self.offers_TBV.reloadData()
        }
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

extension OffersController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        myOffers.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OffersTableViewCell.identifier, for: indexPath) as! OffersTableViewCell
        let exchangeOffer = myOffers[indexPath.section]
        cell.configure(productId: exchangeOffer.productId, productName: exchangeOffer.productName, senderId: exchangeOffer.userId, ownerId: exchangeOffer.ownerId, date: exchangeOffer.date, message: exchangeOffer.message, payment: exchangeOffer.payment)
        //cell.delegate = self
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
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
