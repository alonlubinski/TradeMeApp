//
//  AllProductsTableViewCell.swift
//  TradeMe
//
//  Created by user196691 on 7/1/21.
//

import UIKit

protocol AllProductsTableViewCellDelegate: AnyObject {
    func seeOwnerTapped(id: String)
    func offerTapped(productId: String, productName: String, ownerId: String)
}

class AllProductsTableViewCell: UITableViewCell {
    
    weak var delegate: AllProductsTableViewCellDelegate?

    @IBOutlet weak var home_LBL_title: UILabel!
    
    @IBOutlet weak var home_LBL_description: UILabel!
    
    
    @IBOutlet weak var home_LBL_date: UILabel!
    
    
    @IBOutlet weak var home_LBL_return: UILabel!
    
    @IBOutlet weak var home_BTN_offer: UIButton!
    
    @IBOutlet weak var home_BTN_owner: UIButton!
    
    @IBOutlet weak var home_IMG_image: UIImageView!
    
    private var ownerId: String = ""
    
    private var productId: String = ""
    
    private var productName: String = ""
    
    
    static let identifier = "AllProductsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "AllProductsTableViewCell", bundle: nil)
    }
    
    public func configure(productId: String, ownerId: String, title: String, description: String, cost: String, image: UIImage, date: String){
        self.productId = productId
        self.ownerId = ownerId
        self.productName = title
        home_LBL_title.text = title
        home_LBL_description.text = description
        home_LBL_return.text = "Cost: \(cost)"
        home_IMG_image.image = image
        home_LBL_date.text = date
        Styles.filledButton(home_BTN_offer)
        Styles.transparentButton(home_BTN_owner)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func offerTapped(_ sender: Any) {
        delegate?.offerTapped(productId: productId, productName: productName, ownerId: ownerId)
    }
    
    
    @IBAction func seeOwnerTapped(_ sender: Any) {
        delegate?.seeOwnerTapped(id: ownerId)
    }
    
}
