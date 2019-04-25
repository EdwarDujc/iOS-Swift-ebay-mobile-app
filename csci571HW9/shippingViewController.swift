//
//  shippingViewController.swift
//  csci571HW9
//
//  Created by Jincheng Du on 4/20/19.
//  Copyright © 2019 Jincheng Du. All rights reserved.
//

import UIKit
import SwiftSpinner
import Toast_Swift
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

class shippingViewController: UIViewController {
    @IBOutlet weak var sellerCaptionLabel: UILabel!
    @IBOutlet weak var shippingCaptionLabel: UILabel!
    @IBOutlet weak var returnCaptionLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var feedbackScoreLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var globalShippingLabel: UILabel!
    @IBOutlet weak var handlingTimeLabel: UILabel!
    @IBOutlet weak var policyLabel: UILabel!
    @IBOutlet weak var refundModeLabel: UILabel!
    @IBOutlet weak var returnWithLabel: UILabel!
    @IBOutlet weak var shippingPaidLabel: UILabel!
    
    @IBOutlet weak var sellerCaptionImage: UIImageView!
    @IBOutlet weak var shippingCaptionImage: UIImageView!
    @IBOutlet weak var returnCaptionImage: UIImageView!
    
    @IBOutlet weak var storeNameKey: UILabel!
    @IBOutlet weak var feedbackScoreKey: UILabel!
    @IBOutlet weak var popularityKey: UILabel!
    @IBOutlet weak var feedbackStarKey: UILabel!
    @IBOutlet weak var shippingCostKey: UILabel!
    @IBOutlet weak var globalShippingKey: UILabel!
    @IBOutlet weak var handlingTimeKey: UILabel!
    @IBOutlet weak var policyKey: UILabel!
    @IBOutlet weak var refundModeKey: UILabel!
    @IBOutlet weak var returnWithKey: UILabel!
    @IBOutlet weak var shippingPaidKey: UILabel!
    
    
    var productSearch: Item!
    var storeUrl = "www.google.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sellerCaptionLabel.layer.addBorder(edge: UIRectEdge.top, color: UIColor.lightGray, thickness: 0.5)
        sellerCaptionLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray, thickness: 0.5)
        shippingCaptionLabel.layer.addBorder(edge: UIRectEdge.top, color: UIColor.lightGray, thickness: 0.5)
        shippingCaptionLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray, thickness: 0.5)
        
        returnCaptionLabel.layer.addBorder(edge: UIRectEdge.top, color: UIColor.lightGray, thickness: 0.5)
        returnCaptionLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray, thickness: 0.5)
        
        
        let url = "http://csci571-jincheng-nodejs.us-east-2.elasticbeanstalk.com/details?itemId=" + productSearch.id
        //                print(url)
        SwiftSpinner.show("Fetching Shipping Deta...")
        Alamofire.request(URLRequest(url: URL(string: url)! )).responseSwiftyJSON{
            response in
            SwiftSpinner.hide()
            if let result = response.result.value {
                let item = result["Item"]
                // seller
                // store name
                self.storeNameLabel.text = item["Storefront"]["StoreName"].string ?? ""
                self.storeUrl = item["Storefront"]["StoreURL"].string ?? ""
                if(self.storeNameLabel.text == ""){
                    self.storeNameLabel.isHidden = true
                    self.storeNameKey.isHidden = true
                }
                // feedback score
                self.feedbackScoreLabel.text = String(item["Seller"]["FeedbackScore"].int ?? -1)
                if(self.feedbackScoreLabel.text == "-1"){
                    self.feedbackScoreLabel.isHidden = true
                    self.feedbackScoreKey.isHidden = true
                }
                // popularity
                self.popularityLabel.text = String(item["Seller"]["PositiveFeedbackPercent"].int ?? -1)
                if(self.popularityLabel.text == "-1"){
                    self.popularityLabel.isHidden = true
                    self.popularityKey.isHidden = true
                }
                // Feedback Star
                let feedbackStar = item["Seller"]["FeedbackRatingStar"].string ?? ""
                switch feedbackStar{
                case "Yellow":
                    self.starImage.image = UIImage(named: "starBorder")
                    self.starImage.setImageColor(color:UIColor.yellow)
                case "Blue":
                    self.starImage.image = UIImage(named: "starBorder")
                    self.starImage.setImageColor(color:UIColor.blue)
                case "Turquoise":
                    self.starImage.image = UIImage(named: "starBorder")
                    self.starImage.setImageColor(color:UIColor(
                        red: CGFloat((0x40E0D0 & 0xFF0000) >> 16) / 255.0,
                        green: CGFloat((0x40E0D0 & 0x00FF00) >> 8) / 255.0,
                        blue: CGFloat(0x40E0D0 & 0x0000FF) / 255.0,
                        alpha: CGFloat(1.0)
                    ))
                case "Purple":
                    self.starImage.image = UIImage(named: "starBorder")
                    self.starImage.setImageColor(color:UIColor.purple)
                case "Red":
                    self.starImage.image = UIImage(named: "starBorder")
                    self.starImage.setImageColor(color:UIColor.red)
                case "Green":
                    self.starImage.image = UIImage(named: "starBorder")
                    self.starImage.setImageColor(color:UIColor.green)
                case "YellowShooting":
                    self.starImage.image = UIImage(named: "star")
                    self.starImage.setImageColor(color:UIColor.green)
                case "TurquoiseShooting":
                    self.starImage.image = UIImage(named: "star")
                    self.starImage.setImageColor(color:UIColor(
                        red: CGFloat((0x40E0D0 & 0xFF0000) >> 16) / 255.0,
                        green: CGFloat((0x40E0D0 & 0x00FF00) >> 8) / 255.0,
                        blue: CGFloat(0x40E0D0 & 0x0000FF) / 255.0,
                        alpha: CGFloat(1.0)))
                case "PurpleShooting":
                    self.starImage.image = UIImage(named: "star")
                    self.starImage.setImageColor(color:UIColor.purple)
                case "RedShooting":
                    self.starImage.image = UIImage(named: "star")
                    self.starImage.setImageColor(color:UIColor.red)
                case "GreenShooting":
                    self.starImage.image = UIImage(named: "star")
                    self.starImage.setImageColor(color:UIColor.green)
                case "SilverShooting":
                    self.starImage.image = UIImage(named: "star")
                    self.starImage.setImageColor(color:UIColor(
                        red: CGFloat((0xC0C0C0 & 0xFF0000) >> 16) / 255.0,
                        green: CGFloat((0xC0C0C0 & 0x00FF00) >> 8) / 255.0,
                        blue: CGFloat(0xC0C0C0 & 0x0000FF) / 255.0,
                        alpha: CGFloat(1.0)))
                
                default:
                    self.starImage.isHidden = true
                    self.feedbackStarKey.isHidden = true
                }
                // Shipping Info
                // Shipping Cost
                if (self.productSearch.shipping == "FREE"){
                    self.shippingCostLabel.text = self.productSearch.shipping                }
                else if (self.productSearch.shipping != "N.A."){
                    self.shippingCostLabel.text = self.productSearch.shipping
                }
                else {
                    self.shippingCostLabel.isHidden = true
                    self.shippingCostKey.isHidden = true
                }
                // Global Shipping
                let globalShipping = item["GlobalShipping"].bool ?? false
                if (globalShipping) {
                    self.globalShippingLabel.text = "Yes"
                } else {
                    self.globalShippingLabel.text = "No"
                }
                // handling time
                let handlingTime = item["HandlingTime"].int ?? -1
                if (handlingTime == 0 || handlingTime == 1){
                    self.handlingTimeLabel.text = String(handlingTime) + " Day"
                } else if (handlingTime > 1) {
                    self.handlingTimeLabel.text = String(handlingTime) + " Days"
                } else {
                    self.handlingTimeLabel.isHidden = true
                    self.handlingTimeKey.isHidden = true
                }
                // Return Policy
                // Policy
                let policy = item["ReturnPolicy"]["ReturnsAccepted"].string ?? ""
                switch policy{
                case "ReturnsNotAccepted":
                    self.policyLabel.text = "Returns Not Accepted"
                case "ReturnsAccepted":
                    self.policyLabel.text = "Returns Accepted"
                default:
                    self.policyLabel.isHidden = true
                    self.policyKey.isHidden = true
                }
                //Refund Mode
                self.refundModeLabel.numberOfLines = 2
                self.refundModeLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
                self.refundModeLabel.text = item["ReturnPolicy"]["Refund"].string ?? ""
                if (self.refundModeLabel.text == "") {
                    self.refundModeLabel.isHidden = true
                    self.refundModeKey.isHidden = true
                }
                //Return Within
                self.returnWithLabel.text = item["ReturnPolicy"]["ReturnsWithin"].string ?? ""
                if(self.returnWithLabel.text == "") {
                    self.returnWithLabel.isHidden = true
                    self.returnWithKey.isHidden = true
                }
                //Shipping Cost Paid By
                self.shippingPaidLabel.text = item["ReturnPolicy"]["ShippingCostPaidBy"].string ?? ""
                if (self.shippingPaidLabel.text == ""){
                    self.shippingPaidLabel.isHidden = true
                    self.shippingPaidKey.isHidden = true
                }
                
                // hide section
                if (self.storeNameKey.isHidden && self.feedbackScoreKey.isHidden && self.popularityKey.isHidden && self.feedbackStarKey.isHidden){
                    self.sellerCaptionImage.isHidden = true
                    self.sellerCaptionLabel.isHidden = true
                }
                
                if (self.policyKey.isHidden && self.refundModeKey.isHidden && self.returnWithKey.isHidden && self.shippingPaidKey.isHidden) {
                    self.returnCaptionImage.isHidden = true
                    self.returnCaptionLabel.isHidden = true
                }
                
                
            } // item = response.result.value
        } //responseSwiftyJSON
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClicLabel(sender:)))
        storeNameLabel.isUserInteractionEnabled = true
        storeNameLabel.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    // For Store Name hyperlink
    @objc func onClicLabel(sender:UITapGestureRecognizer) {
        let url = self.storeUrl
        openUrl(urlString: url)
    }
    
    func openUrl(urlString:String!) {
        var url = URL(string: "www.ebay.com")!
        if(urlString != ""){
            url = URL(string: urlString)!
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
