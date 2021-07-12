//
//  ExchangeTableViewCell.swift
//  TradeMe
//
//  Created by user196691 on 7/5/21.
//

import UIKit
import Firebase

protocol ExchangeTableViewCellDelegate: AnyObject {
    func seeExchangerTapped(id: String)
    func rateTapped(id: String)
}

class ExchangeTableViewCell: UITableViewCell {

    weak var delegate: ExchangeTableViewCellDelegate?
    
    @IBOutlet weak var exchange_LBL_title: UILabel!
    
    @IBOutlet weak var exchange_LBL_description: UILabel!
    
    @IBOutlet weak var exchange_LBL_date: UILabel!
    
    @IBOutlet weak var exchange_BTN_watch: UIButton!
    
    
    @IBOutlet weak var exchange_BTN_rate: UIButton!
    
    private var userProductName: String = ""
    
    private var exchangedProductName: String = ""
    
    private var exchangerUserId: String = ""
    
    static let identifier = "ExchangeTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ExchangeTableViewCell", bundle: nil)
    }
    
    public func configure(exchange: Exchange){
        let email = Auth.auth().currentUser?.email
        if(email == exchange.ownerId){
            userProductName = exchange.productName
            exchangedProductName = exchange.payment
            exchangerUserId = exchange.userId
        } else {
            userProductName = exchange.payment
            exchangedProductName = exchange.productName
            exchangerUserId = exchange.ownerId
        }
        exchange_LBL_title.text = "\(userProductName) <-> \(exchangedProductName)"
        exchange_LBL_description.text = "You have exchanged your \(userProductName) for \(exchangedProductName)"
        exchange_LBL_date.text = exchange.date
        Styles.transparentButton(exchange_BTN_watch)
        Styles.filledButton(exchange_BTN_rate)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func watchTapped(_ sender: Any) {
        delegate?.seeExchangerTapped(id: exchangerUserId)
    }
    
    
    @IBAction func rateTapped(_ sender: Any) {
        delegate?.rateTapped(id: exchangerUserId)
    }
}
