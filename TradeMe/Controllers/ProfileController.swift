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
    
    let user = Firebase.Auth.auth().currentUser
    let db = Firebase.Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let email = user?.email
        db.collection("users").document(email!).getDocument{ (document, error) in
            if let document = document, document.exists {
                let firstName = document.get("firstName") as! String
                let lastName = document.get("lastName") as! String
                let userEmail = document.get("email") as! String
                self.profile_LBL_name.text = "\(firstName) \(lastName)"
                self.profile_LBL_email.text = "\(userEmail)"
            } else {
                print("Document does not exist")
            }
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
