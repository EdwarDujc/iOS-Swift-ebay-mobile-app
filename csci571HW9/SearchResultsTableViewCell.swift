//
//  SearchResultsTableViewCell.swift
//  csci571HW9
//
//  Created by Jincheng Du on 4/18/19.
//  Copyright © 2019 Jincheng Du. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {

    // properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var shippingLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var wishButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
