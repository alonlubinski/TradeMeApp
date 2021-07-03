//
//  OffersTableViewCell.swift
//  TradeMe
//
//  Created by user196691 on 7/3/21.
//

import UIKit

class OffersTableViewCell: UITableViewCell {

    @IBOutlet weak var offers_LBL_title: UILabel!
    
    @IBOutlet weak var offers_LBL_message: UILabel!
    
    @IBOutlet weak var offers_LBL_payment: UILabel!
    
    @IBOutlet weak var offers_LBL_sender: UILabel!
    
    
    @IBOutlet weak var offers_LBL_date: UILabel!
    
    
    @IBOutlet weak var offers_BTN_accept: UIButton!
    
    @IBOutlet weak var offers_BTN_decline: UIButton!
    
    static let identifier = "OffersTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "OffersTableViewCell", bundle: nil)
    }
    
    public func configure(productId: String, productName: String, senderId: String, ownerId: String, date: String, message: String, payment: String) {
        offers_LBL_title.text = productName
        offers_LBL_message.text = message
        offers_LBL_payment.text = payment
        offers_LBL_sender.text = senderId
        offers_LBL_date.text = date
        Styles.filledButton(offers_BTN_accept)
        Styles.transparentButton(offers_BTN_decline)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
    }
    
    @IBAction func declineTapped(_ sender: Any) {
    }
    
}
