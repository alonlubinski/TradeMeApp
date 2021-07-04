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
    
    func showAcceptConfirmationDialog(_ exchangeOffer: ExchangeOffer){
        let acceptDialog = UIAlertController(title: "Accept Offer", message: "Are you sure? All offers for this product will be deleted.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { UIAlertAction in
            // add exchange
            // delete all offers relared to the product
            // delete product
            self.firebaseManager.deleteProductByProductId(exchangeOffer.productId) {
                self.firebaseManager.getExchangeOffersIdsByProductId(exchangeOffer.productId) { offerIds in
                    self.firebaseManager.deleteExchangeOffersByOfferIds(offerIds) {
                        self.firebaseManager.addExchange(exchangeOffer.productId, exchangeOffer.productName, exchangeOffer.ownerId, exchangeOffer.userId, exchangeOffer.payment)
                    }
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        acceptDialog.addAction(confirmAction)
        acceptDialog.addAction(cancelAction)
        present(acceptDialog, animated: true, completion: nil)
    }
    
    func showDeclineConfirmationDialog(_ offerId: String){
        let declineDialog = UIAlertController(title: "Decline Offer", message: "Are you sure? You will not be able to see this offer again.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { UIAlertAction in
            guard let arrIndex =  self.myOffers.firstIndex(where: {$0.offerId == offerId})
                  else {
                return
            }
            self.myOffers.remove(at: arrIndex)
            self.firebaseManager.deleteExchangeOfferByExchangeOfferId(offerId) {
                self.offers_TBV.reloadData()
            }
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { UIAlertAction in
            self.dismiss(animated: true, completion: nil)
        }
        declineDialog.addAction(confirmAction)
        declineDialog.addAction(cancelAction)
        present(declineDialog, animated: true, completion: nil)
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
        cell.configure(exchangeOffer: exchangeOffer)
        cell.delegate = self
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

extension OffersController: OffersTableViewCellDelegate {
    
    func accpetTapped(exchangeOffer: ExchangeOffer) {
        self.showAcceptConfirmationDialog(exchangeOffer)
    }
    
    func declineTapped(offerId: String) {
        self.showDeclineConfirmationDialog(offerId)
    }
}
