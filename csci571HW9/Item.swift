//
//  productSearch.swift
//  csci571HW9
//
//  Created by Jincheng Du on 4/18/19.
//  Copyright © 2019 Jincheng Du. All rights reserved.
//

import UIKit
class Item {
    // Properties
    var id: String
    var title: String
    var price: String
    var shipping: String
    var zipcode: String
    var condition: String
    var photo: UIImage
    var wishButton: UIButton
    var isInCart: Bool
    
    init?(id: String, title: String, price: String, shipping: String, zipcode: String, condition: String, photo: UIImage, wishButton: UIButton, isInCart: Bool) {
        self.id = id
        self.title = title
        self.price = price
        self.shipping = shipping
        self.zipcode = zipcode
        self.condition = condition
        self.photo = photo
        self.wishButton = wishButton
        self.isInCart = isInCart
    }
}
