//
//  TabBarViewController.swift
//  csci571HW9
//
//  Created by Jincheng Du on 4/19/19.
//  Copyright © 2019 Jincheng Du. All rights reserved.
//

import UIKit
import SwiftSpinner
import Toast_Swift
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

class TabBarViewController: UITabBarController {

    var product: Item?
    var item_title: String?
    var detailsJson: JSON?
    
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
    
    @objc func facebookButtonAction(){
        var url = "https://www.facebook.com/sharer/sharer.php?u="
        let productName = product?.title ?? "Unkonwn Title"
        let price = product?.price ?? "Unknown price"
        let link = product?.viewUrl ?? "www.ebay.com"
        var text = "Buy " + productName
        text += " at "
        text += price + " from link below"
        
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        text = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        url += link + "&quote=" + text
        openUrl(urlString: url)
    }
    
    @objc func wishButtonAction(){
        print("to implement: wish list")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        item_title = product?.title
        self.navigationController!.navigationBar.topItem!.title = ""
        
        let facebookButton = UIBarButtonItem(title: "fb", style: .plain, target: self, action: #selector(facebookButtonAction))
        
        facebookButton.image = UIImage(named: "facebook")
        
        let wishButton = UIBarButtonItem(title: "wl", style: .plain, target: self, action: #selector(wishButtonAction))
        
        wishButton.image = UIImage(named: "wishListEmpty")
        
        self.navigationItem.rightBarButtonItems = [ wishButton, facebookButton]
        
        if let infoView = self.viewControllers![0] as? InfoViewController {
            infoView.productSearch = self.product!
        }
        
        if let shippingView = self.viewControllers![1] as? shippingViewController {
            shippingView.productSearch = self.product!
        }
        
        if let photoView = self.viewControllers![2] as? PhotoViewController {
            photoView.itemTitle = self.product!.title
        }
        
        if let similarView = self.viewControllers![3] as? SimilarViewController {
            similarView.itemId = self.product!.id
        }

    }
    
    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if let vc1 = segue.destination as? InfoViewController  {
//            vc1.detailsJson = self.detailsJson
//        }
//    }

}
