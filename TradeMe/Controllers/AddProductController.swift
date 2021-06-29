//
//  AddProductController.swift
//  TradeMe
//
//  Created by user196691 on 6/28/21.
//

import UIKit
import Firebase

class AddProductController: UIViewController {

    let db = Firebase.Firestore.firestore()
    let storage = Firebase.Storage.storage().reference()
    
    @IBOutlet weak var add_EDT_name: UITextField!
    
    
    @IBOutlet weak var add_EDT_description: UITextField!
    
    
    @IBOutlet weak var add_IMG_image: UIImageView!
    
    
    @IBOutlet weak var add_BTN_pick: UIButton!
    
    @IBOutlet weak var add_EDT_return: UITextField!
    
    
    @IBOutlet weak var add_LBL_error: UILabel!
    
    
    @IBOutlet weak var add_BTN_post: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        // Do any additional setup after loading the view.
        
    }
    
    func setUpViews() {
        Styles.textField(add_EDT_name)
        Styles.textField(add_EDT_description)
        Styles.transparentButton(add_BTN_pick)
        Styles.textField(add_EDT_return)
        Styles.filledButton(add_BTN_post)
    }
    
    func validateForm() -> String? {
        if(!Validation.fieldIsNotEmpty(add_EDT_name) || !Validation.fieldIsNotEmpty(add_EDT_description) || !Validation.fieldIsNotEmpty(add_EDT_return)){
            return "Please fill all the fields"
        }
        return nil
    }
    
    
    @IBAction func pickImageTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
    @IBAction func postProductTapped(_ sender: Any) {
        let error = validateForm()
        if error != nil {
            add_LBL_error.text = error
            add_LBL_error.alpha = 1
        } else {
            let id = UUID().uuidString
            let owner = Firebase.Auth.auth().currentUser?.email
            let name = add_EDT_name.text
            let description = add_EDT_description.text
            guard let image = add_IMG_image.image?.pngData() else {
                return
            }
            let cost = add_EDT_return.text
            let ref = storage.child("products/\(id).png")
            ref.putData(image, metadata: nil) { _, error in
                if(error == nil){
                    self.add_LBL_error.alpha = 0
                    self.db.collection("products").document(id).setData(
                        ["id": id,
                         "owner": owner!,
                         "name": name!,
                         "description": description!,
                         "return": cost!])
                    self.add_EDT_name.text = ""
                    self.add_EDT_description.text = ""
                    self.add_IMG_image.image = UIImage(systemName: "photo")
                    self.add_EDT_return.text = ""
                } else {
                    self.add_LBL_error.alpha = 1
                    self.add_LBL_error.text = "Something went wrong..."
                }
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


extension AddProductController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            add_IMG_image.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
