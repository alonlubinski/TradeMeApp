//
//  ProfileController.swift
//  TradeMe
//
//  Created by user196691 on 6/26/21.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    @IBOutlet weak var profile_LBL_name: UILabel!
    
    @IBOutlet weak var profile_LBL_email: UILabel!
    
    @IBOutlet weak var profile_LBL_rating: UILabel!
    
    @IBOutlet weak var profile_BTN_logout: UIButton!
    
    @IBOutlet weak var profile_TBV: UITableView!
    
    let user = Firebase.Auth.auth().currentUser
    let db = Firebase.Firestore.firestore()
    
    let firebaseManager = FirebaseManager()
    var myExchanges: [Exchange] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpViews()
        profile_TBV.register(ExchangeTableViewCell.nib(), forCellReuseIdentifier: ExchangeTableViewCell.identifier)
        profile_TBV.delegate = self
        profile_TBV.dataSource = self
        let email = user?.email
        db.collection("users").document(email!).getDocument{ (document, error) in
            if let document = document, document.exists {
                let firstName = document.get("firstName") as! String
                let lastName = document.get("lastName") as! String
                let userEmail = document.get("email") as! String
                let rating = document.get("rating") as! Double
                let numOfRates = document.get("numOfRates") as! Double
                var calculatedRating = 0.0
                if(numOfRates > 0){
                    calculatedRating = rating / numOfRates
                }
                let calculatedRatingStr: String = String(format: "%.2f", calculatedRating)
                let numOfRatesStr: String = String(format: "%.0f", numOfRates)
                self.profile_LBL_name.text = "\(firstName) \(lastName)"
                self.profile_LBL_email.text = "\(userEmail)"
                self.profile_LBL_rating.text = "Rating (num of rates): \(calculatedRatingStr) (\(numOfRatesStr))"
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let email = user?.email
        firebaseManager.getAllExchangesByUserId(email!, "ownerId") { ownerExchanges in
            self.myExchanges.removeAll()
            self.myExchanges.append(contentsOf: ownerExchanges)
            self.firebaseManager.getAllExchangesByUserId(email!, "userId") { userExchanges in
                self.myExchanges.append(contentsOf: userExchanges)
                self.myExchanges = self.myExchanges.sorted(by: {$0.dateInterval > $1.dateInterval})
                print(self.myExchanges.count)
                RunLoop.main.perform {
                    self.profile_TBV.reloadData()
                }
            }
        }
    }
    
    // Init styles to the views
    func setUpViews() {
        Styles.transparentButton(profile_BTN_logout)
    }
    
    // Function that shows exchanger info dialog
    func showSeeExchangerDialog(_ name: String, _ email: String, _ rating: String, _ numOfRates: String) {
        let offerDialog = UIAlertController(title: name, message: "\(email)\nRating (num of rates): \(rating) (\(numOfRates))", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                self.dismiss(animated: true, completion: nil)
        }
        offerDialog.addAction(okAction)
        present(offerDialog, animated: true, completion: nil)
    }
    
    // Function that shows rate dialog
    func showRateDialog(_ id: String) {
        let rateDialog = UIAlertController(title: "Rate", message: "Please rate the exchanger...", preferredStyle: .alert)
        let badAction = UIAlertAction(title: "Bad", style: .default) { UIAlertAction in
            self.firebaseManager.updateRating(id, 1) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { UIAlertAction in
            self.firebaseManager.updateRating(id, 2) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        let goodAction = UIAlertAction(title: "Good", style: .default) { UIAlertAction in
            self.firebaseManager.updateRating(id, 3) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        let veryGoodAction = UIAlertAction(title: "Very Good", style: .default) { UIAlertAction in
            self.firebaseManager.updateRating(id, 4) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        let excellentAction = UIAlertAction(title: "Excellent", style: .default) { UIAlertAction in
            self.firebaseManager.updateRating(id, 5) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        rateDialog.addAction(badAction)
        rateDialog.addAction(okAction)
        rateDialog.addAction(goodAction)
        rateDialog.addAction(veryGoodAction)
        rateDialog.addAction(excellentAction)
        present(rateDialog, animated: true, completion: nil)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        do{
           try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(identifier: "MainNavigationController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)

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

extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if myExchanges.count == 0 {
            tableView.setEmptyMessage("No exchanges to display")
        } else {
            tableView.restore()
        }
        return myExchanges.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeTableViewCell.identifier, for: indexPath) as! ExchangeTableViewCell
        let exchange = myExchanges[indexPath.section]
        cell.configure(exchange: exchange)
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

extension ProfileController: ExchangeTableViewCellDelegate {
    func seeExchangerTapped(id: String) {
        firebaseManager.getUserDetailsByUserId(id) { fullName, rating, numOfRates in
            self.showSeeExchangerDialog(fullName, id, rating, numOfRates)
        }
    }
    
    func rateTapped(id: String) {
        self.showRateDialog(id)
    }
}
