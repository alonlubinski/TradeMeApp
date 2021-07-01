//
//  MyProductTableViewCell.swift
//  TradeMe
//
//  Created by user196691 on 6/30/21.
//

import UIKit

class MyProductTableViewCell: UITableViewCell {

    
    @IBOutlet weak var my_LBL_title: UILabel!
    
    @IBOutlet weak var my_LBL_description: UILabel!
    
    
    @IBOutlet weak var my_LBL_date: UILabel!
    
    @IBOutlet weak var my_LBL_return: UILabel!
    
    @IBOutlet weak var my_BTN_delete: UIButton!
    
    @IBOutlet weak var my_IMG_image: UIImageView!
    
    static let identifier = "MyProductTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MyProductTableViewCell", bundle: nil)
    }
    
    public func configure(title: String, description: String, cost: String, image: UIImage){
        my_LBL_title.text = title
        my_LBL_description.text = description
        my_LBL_return.text = cost
        my_IMG_image.image = image
        Styles.transparentButton(my_BTN_delete)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
    }
}
