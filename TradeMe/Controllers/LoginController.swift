//
//  ViewController.swift
//  TradeMe
//
//  Created by user196684 on 6/9/21.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    
    @IBOutlet weak var login_LBL_welcome: UILabel!
    
    
    @IBOutlet weak var login_EDT_email: UITextField!
    
    @IBOutlet weak var login_EDT_password: UITextField!
    
    
    @IBOutlet weak var login_BTN_login: UIButton!
    
    
    @IBOutlet weak var login_BTN_register: UIButton!
    
    
    @IBOutlet weak var login_LBL_error: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //FirebaseApp.configure()
        setUpViews()
    }
    
    // Init styles to the views
    func setUpViews() {
        Styles.textField(login_EDT_email)
        Styles.textField(login_EDT_password)
        Styles.filledButton(login_BTN_login)
        Styles.transparentButton(login_BTN_register)
    }
    
    // Function that check if the form is filled right, if not it's returns the error
    func validateForm() -> String? {
        if(!Validation.fieldIsNotEmpty(login_EDT_email) || !Validation.fieldIsNotEmpty(login_EDT_password)){
            return "Please fill all the fields"
        }
        let email = login_EDT_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(!Validation.emailIsValid(email)){
            return "Please fill valid email"
        }
        return nil
    }

    @IBAction func loginPressed(_ sender: Any) {
        let error = validateForm()
        if(error != nil){
            login_LBL_error.text = error!
            login_LBL_error.alpha = 1
        } else {
            let email = login_EDT_email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = login_EDT_password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: password) {
                (result, err) in
                if err != nil {
                    self.login_LBL_error.text = err!.localizedDescription
                    self.login_LBL_error.alpha = 1
                } else {
                    self.login_LBL_error.alpha = 0
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainTabBarController = storyboard.instantiateViewController(identifier: "MainTabBarController")
                    (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                }
            }
        }
    }
    
}

