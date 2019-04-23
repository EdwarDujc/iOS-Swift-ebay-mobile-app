//
//  SimilarViewController.swift
//  csci571HW9
//
//  Created by Jincheng Du on 4/21/19.
//  Copyright © 2019 Jincheng Du. All rights reserved.
//

import UIKit
import SwiftSpinner
import Toast_Swift
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

class SimilarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortKeySegControl: UISegmentedControl!
    @IBOutlet weak var sortOrderSegControl: UISegmentedControl!
    
    
    @IBAction func sortOrderAction(_ sender: Any) {
        switch sortKeySegControl.selectedSegmentIndex{
        case 1:
            sortOrderSegControl.isEnabled = true
            similarItems = similarItems.sorted(by: {(first, second) -> Bool in
                let fir=first;
                let sec=second;
                return fir["title"].string! < sec["title"].string!;
            })
        case 2:
            sortOrderSegControl.isEnabled = true
            similarItems = similarItems.sorted(by: {(first, second) -> Bool in
                let fir=first;
                let sec=second;
                return fir["price"].double! < sec["price"].double!;
            })
        case 3:
            sortOrderSegControl.isEnabled = true
            similarItems = similarItems.sorted(by: {(first, second) -> Bool in
                let fir=first;
                let sec=second;
                return fir["leftDay"].double! < sec["leftDay"].double!;
            })
        case 4:
            sortOrderSegControl.isEnabled = true
            similarItems = similarItems.sorted(by: {(first, second) -> Bool in
                let fir=first;
                let sec=second;
                return fir["shippingCost"].double! < sec["shippingCost"].double!;
            })
        case 0:
            sortOrderSegControl.isEnabled = false
        default:
            break
        }
        
        if(sortOrderSegControl.selectedSegmentIndex == 1){
            similarItems = similarItems.reversed()
        }
        
        collectionView.reloadData()
    }
    
    var item1:JSON!
    var item2:JSON!
    var item3:JSON!
    var item4:JSON!
    var item5:JSON!
    var item6:JSON!
    var similarItems:[JSON] = []
    var itemId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        sortOrderSegControl.isEnabled = false
        
//        itemId = "163648524871"
        
        let url = "http://csci571-jincheng-nodejs.us-east-2.elasticbeanstalk.com/similar?itemId=" + itemId
        SwiftSpinner.show("Fetching Similar Items...")
        Alamofire.request(URLRequest(url: URL(string: url)! )).responseSwiftyJSON{
            response in
            SwiftSpinner.hide()
            if let result = response.result.value {
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                for index in 0...result["getSimilarItemsResponse"]["itemRecommendations"
                    ]["item"].count-1{
                        let itemResult = result["getSimilarItemsResponse"]["itemRecommendations"
                            ]["item"][index]
                        var tmpItem:JSON = [
                            "title": "",
                            "image": "",
                            "shippingCost": -1.0,
                            "leftDay": -1,
                            "price": -1,
                            "viewItemURL": ""
                        ]
                        tmpItem["title"] = itemResult["title"]
                        tmpItem["image"] =  itemResult["imageURL"]
                        
                        tmpItem["shippingCost"] = JSON((itemResult["shippingCost"]["__value__"].string as! NSString).doubleValue)
                        
                        let timeLeftString = itemResult["timeLeft"].string
                        let pIndex = timeLeftString!.index(of: "P")
                        let pIndexNext = timeLeftString!.index(after: pIndex!)
                        let dIndex = timeLeftString!.index(of: "D")
                        let dIndexNext = timeLeftString!.index(before: dIndex!)
                        let newStr = timeLeftString![pIndexNext...dIndexNext]
                        tmpItem["leftDay"] = JSON((newStr as! NSString).intValue)
                        
                        tmpItem["price"] = JSON((itemResult["buyItNowPrice"]["__value__"].string as! NSString).doubleValue)
                        
                        tmpItem["viewItemURL"] = itemResult["viewItemURL"]
                        
                        self.similarItems.append(tmpItem)
                }
            }
        }
        
        
    } // viewdidload
    
    func collectionView(_ collectionView:  UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarCell", for: indexPath) as! SimilarCollectionViewCell
        
        let imageUrl = URL(string: similarItems[indexPath.item]["image"].string ?? "")!
        let imageData = try! Data(contentsOf: imageUrl)
        let photo = UIImage(data: imageData) ?? UIImage(named: "defaultImage")
        cell.productImage.image = photo
        
//        cell.productImage.image = UIImage(named: "trojan")
        cell.titleLabel.text = similarItems[indexPath.item]["title"].string ?? ""
        cell.titleLabel.numberOfLines = 3
        cell.titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        cell.shippingCostLabel.text = "$" + String(similarItems[indexPath.item]["shippingCost"].int ?? -1)
        let daysLeftInt = similarItems[indexPath.item]["leftDay"].int ?? -1
        if (daysLeftInt <= 1){
            cell.daysLeftLabel.text = String(daysLeftInt) + " Day Left"
        } else {
            cell.daysLeftLabel.text = String(daysLeftInt) + " Days Left"
        }
        cell.priceLabel.text = "$" + String(similarItems[indexPath.item]["price"].int ?? -1)
//        cell.viewItemURL = similarItems[indexPath.item]["viewItemURL"].string ?? "www.ebay.com"
        
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = similarItems[indexPath.item]
        let url = cell["viewItemURL"].string ?? "www.ebay.com"
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
