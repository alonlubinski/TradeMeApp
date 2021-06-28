//
//  SignUpController.swift
//  TradeMe
//
//  Created by user196684 on 6/11/21.
//

import UIKit
import Firebase

class SignUpController: UIViewController {

    
    @IBOutlet weak var register_EDT_first: UITextField!
    
    @IBOutlet weak var register_EDT_last: UITextField!
    
    @IBOutlet weak var register_EDT_email: UITextField!
    
    @IBOutlet weak var register_EDT_password: UITextField!
    
    @IBOutlet weak var register_EDT_password2: UITextField!
    
    
    @IBOutlet weak var register_BTN_register: UIButton!
    
    
    @IBOutlet weak var register_LBL_error: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        // Do any additional setup after loading the view.
    }
    
    func setUpViews() {
        Styles.textField(register_EDT_first)
        Styles.textField(register_EDT_last)
        Styles.textField(register_EDT_email)
        Styles.textField(register_EDT_password)
        Styles.textField(register_EDT_password2)
        Styles.filledButton(register_BTN_register)
    }
    
    func validateForm() -> String? {
        if(!Validation.fieldIsNotEmpty(register_EDT_email) || !Validation.fieldIsNotEmpty(register_EDT_password) || !Validation.fieldIsNotEmpty(register_EDT_password2) ||
            !Validation.fieldIsNotEmpty(register_EDT_first) ||
            !Validation.fieldIsNotEmpty(register_EDT_last)){
            return "Please fill all the fields"
        }
        let email = register_EDT_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(!Validation.emailIsValid(email)){
            return "Please fill valid email"
        }
        let password1 = register_EDT_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password2 = register_EDT_password2.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(!Validation.passwordsMatch(password1, password2)){
            return "Passwords don't match"
        }
        return nil
    }

    @IBAction func signupTapped(_ sender: Any) {
        let error = validateForm()
        if(error != nil){
            register_LBL_error.text = error!
            register_LBL_error.alpha = 1
        } else {
            let firstName = register_EDT_first.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = register_EDT_last.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = register_EDT_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = register_EDT_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: password) {
                (result, err) in
                if err != nil {
                    self.register_LBL_error.text = err!.localizedDescription
                    self.register_LBL_error.alpha = 1
                } else {
                    let db = Firestore.firestore()
                    db.collection("users").document(email).setData(
                        ["firstName": firstName,
                        "lastName": lastName,
                        "email" : email])
                    self.backToLoginScreen()
                }
            }
        }
    }
    
    func backToLoginScreen() {
        let loginViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginController
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
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
