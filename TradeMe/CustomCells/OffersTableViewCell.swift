//
//  OffersTableViewCell.swift
//  TradeMe
//
//  Created by user196691 on 7/3/21.
//

import UIKit

protocol OffersTableViewCellDelegate: AnyObject{
    func accpetTapped(exchangeOffer: ExchangeOffer)
    func declineTapped(offerId: String)
}

class OffersTableViewCell: UITableViewCell {
    
    weak var delegate: OffersTableViewCellDelegate?

    @IBOutlet weak var offers_LBL_title: UILabel!
    
    @IBOutlet weak var offers_LBL_message: UILabel!
    
    @IBOutlet weak var offers_LBL_payment: UILabel!
    
    @IBOutlet weak var offers_LBL_sender: UILabel!
    
    
    @IBOutlet weak var offers_LBL_date: UILabel!
    
    
    @IBOutlet weak var offers_BTN_accept: UIButton!
    
    @IBOutlet weak var offers_BTN_decline: UIButton!
    
    static let identifier = "OffersTableViewCell"
    
    private var offerId: String = ""
    
    private var exchangeOffer: ExchangeOffer!
    
    static func nib() -> UINib {
        return UINib(nibName: "OffersTableViewCell", bundle: nil)
    }
    
    public func configure(exchangeOffer: ExchangeOffer) {
        self.offerId = exchangeOffer.offerId
        self.exchangeOffer = exchangeOffer
        offers_LBL_title.text = exchangeOffer.productName
        offers_LBL_message.text = exchangeOffer.message
        offers_LBL_payment.text = exchangeOffer.payment
        offers_LBL_sender.text = exchangeOffer.userId
        offers_LBL_date.text = exchangeOffer.date
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
        delegate?.accpetTapped(exchangeOffer: exchangeOffer)
    }
    
    @IBAction func declineTapped(_ sender: Any) {
        delegate?.declineTapped(offerId: offerId)
    }
    
}
