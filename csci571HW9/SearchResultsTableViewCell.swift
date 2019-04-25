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
    
    var product:Item!
    var messageToast:ToastProtocol!;
    var isInCart = false
    var myView:SearchResultsTableViewController!
    
    @IBAction func wishButtonAction(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        if var allObject = defaults.dictionary(forKey: "wishList"){
            if let object = allObject[product!.id]{
                allObject.removeValue(forKey: product!.id)
                defaults.set(allObject, forKey: "wishList")
                wishButton.setImage(UIImage(named: "wishListEmpty") , for: UIControl.State.normal)                // toast message
                var message = product?.title ?? "Unknown product"
                message += " was removed from the Wish List"
//                messageToast.message(m:message)
                myView.view.makeToast(message, duration: 1.5, position: .bottom)
            } else {
                allObject[product!.id] = [
                    "id":product!.id,
                    "title":product!.title,
                    "price":product!.price,
                    "shipping":product!.shipping,
                    "zipcode":product!.zipcode,
                    "condition":product!.condition,
                    "photoUrl":product!.photoUrl,
                    "isIncart":product!.isInCart,
                    "viewUrl":product!.viewUrl
                ]
                defaults.set(allObject, forKey: "wishList")
                wishButton.setImage(UIImage(named: "wishListFilled") , for: UIControl.State.normal)
                // toast message
                var message = product?.title ?? "Unknown product"
                message += " was added to the Wish List"
//                messageToast.message(m:message)
                myView.view.makeToast(message, duration: 1.5, position: .bottom)

            }
        } else {
            var cart = [product!.id: [
                "id":product!.id,
                "title":product!.title,
                "price":product!.price,
                "shipping":product!.shipping,
                "zipcode":product!.zipcode,
                "condition":product!.condition,
                "photoUrl":product!.photoUrl,
                "isIncart":product!.isInCart,
                "viewUrl":product!.viewUrl
                ]]
            defaults.set(cart, forKey: "wishList")
            wishButton.setImage(UIImage(named: "wishListFilled") , for: UIControl.State.normal)
            // toast message
            var message = product?.title ?? "Unknown product"
            message += " was added to the Wish List"
//            messageToast.message(m:message)
            myView.view.makeToast(message, duration: 1.5, position: .bottom)

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
