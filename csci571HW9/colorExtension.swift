//
//  colorExtension.swift
//  csci571HW9
//
//  Created by Jincheng Du on 4/21/19.
//  Copyright © 2019 Jincheng Du. All rights reserved.
//

import UIKit
extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
