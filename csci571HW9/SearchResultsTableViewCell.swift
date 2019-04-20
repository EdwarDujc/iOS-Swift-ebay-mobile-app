//
//  SearchResultsTableViewCell.swift
//  csci571HW9
//
//  Created by Jincheng Du on 4/18/19.
//  Copyright © 2019 Jincheng Du. All rights reserved.
//

import UIKit
import Toast_Swift

class SearchResultsTableViewCell: UITableViewCell {

    // properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var wishButton: UIButton!
    
    var isInCart = false
    
    @IBAction func wishButtonAction(_ sender: UIButton) {
//        print("wish button clicked")
        if (self.isInCart){
            self.isInCart = false
            wishButton.setImage(UIImage(named: "wishListEmpty") , for: UIControl.State.normal)
        } else {
            self.isInCart = true
            wishButton.setImage(UIImage(named: "wishListFilled") , for: UIControl.State.normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
