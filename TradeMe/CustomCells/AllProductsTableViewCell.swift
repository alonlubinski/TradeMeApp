//
//  AllProductsTableViewCell.swift
//  TradeMe
//
//  Created by user196691 on 7/1/21.
//

import UIKit

protocol AllProductsTableViewCellDelegate: AnyObject {
    func seeOwnerTapped(with id: String)
    func offerTapped(with id: String)
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
    
    
    static let identifier = "AllProductsTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "AllProductsTableViewCell", bundle: nil)
    }
    
    public func configure(productId: String, ownerId: String, title: String, description: String, cost: String, image: UIImage){
        self.productId = productId
        self.ownerId = ownerId
        home_LBL_title.text = title
        home_LBL_description.text = description
        home_LBL_return.text = cost
        home_IMG_image.image = image
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
        delegate?.offerTapped(with: productId)
    }
    
    
    @IBAction func seeOwnerTapped(_ sender: Any) {
        delegate?.seeOwnerTapped(with: ownerId)
    }
    
}
