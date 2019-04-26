//
//  LinkUILabel.swift
//  csci571HW9
//
//  Created by Jincheng Du on 4/21/19.
//  Copyright © 2019 Jincheng Du. All rights reserved.
//

import UIKit

@IBDesignable
class LinkUILabel: UILabel{
    
    @IBInspectable
    var url: String?{
        didSet{
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.onLabelClic(sender:)))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(tap)
        }
    }
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
        // Tap serviceConditions handler
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onLabelClic(sender:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    private func openUrl(urlString: String!) {
        var url = URL(string: urlString)!
        if(!urlString.starts(with: "http")){
            url = URL(string: "http://" + urlString)!
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @objc func onLabelClic(sender:UITapGestureRecognizer) {
        self.openUrl(urlString: url)
    }
}
