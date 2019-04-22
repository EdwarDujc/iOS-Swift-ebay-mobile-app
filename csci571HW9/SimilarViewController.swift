//
//  SimilarViewController.swift
//  csci571HW9
//
//  Created by Jincheng Du on 4/21/19.
//  Copyright © 2019 Jincheng Du. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON

class SimilarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortKeySegControl: UISegmentedControl!
    @IBOutlet weak var sortOrderSegControl: UISegmentedControl!
    
    
    @IBAction func sortOrderAction(_ sender: Any) {
        switch sortKeySegControl.selectedSegmentIndex{
        case 1:
            similarItems = similarItems.sorted(by: {(first, second) -> Bool in
                let fir=first;
                let sec=second;
                return fir["title"].string! < sec["title"].string!;
            })
        case 2:
            similarItems = similarItems.sorted(by: {(first, second) -> Bool in
                let fir=first;
                let sec=second;
                return fir["price"].double! < sec["price"].double!;
            })
        case 3:
            similarItems = similarItems.sorted(by: {(first, second) -> Bool in
                let fir=first;
                let sec=second;
                return fir["leftDay"].double! < sec["leftDay"].double!;
            })
        case 4:
            similarItems = similarItems.sorted(by: {(first, second) -> Bool in
                let fir=first;
                let sec=second;
                return fir["shippingCost"].double! < sec["shippingCost"].double!;
            })
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        item1 = [
            "title": "gNew Authentic Prada Sunglasses PR 13RS TWC/0A7 RED HAVANA",
            "image": UIImage(named: "trojan"),
            "shippingCost": 11,
            "leftDay": 6,
            "price": 400
        ]
        
        item2 = [
            "title": "bNew Authentic Prada Sunglasses PR 13RS TWC/0A7 RED HAVANA",
            "image": UIImage(named: "trojan"),
            "shippingCost": 21,
            "leftDay": 4,
            "price": 500
        ]
        
        item3 = [
            "title": "fNew Authentic Prada Sunglasses PR 13RS TWC/0A7 RED HAVANA",
            "image": UIImage(named: "trojan"),
            "shippingCost": 31,
            "leftDay": 5,
            "price": 600
        ]
        
        item4 = [
            "title": "dNew Authentic Prada Sunglasses PR 13RS TWC/0A7 RED HAVANA",
            "image": UIImage(named: "trojan"),
            "shippingCost": 41,
            "leftDay": 1,
            "price": 300
        ]
        
        item5 = [
            "title": "cNew Authentic Prada Sunglasses PR 13RS TWC/0A7 RED HAVANA",
            "image": UIImage(named: "trojan"),
            "shippingCost": 51,
            "leftDay": 2,
            "price": 100
        ]
        
        item6 = [
            "title": "eNew Authentic Prada Sunglasses PR 13RS TWC/0A7 RED HAVANA",
            "image": UIImage(named: "trojan"),
            "shippingCost": 61,
            "leftDay": 3,
            "price": 200
        ]
        
        similarItems = [item1, item2, item3, item4, item5, item6]
        
    } // viewdidload
    
    func collectionView(_ collectionView:  UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarCell", for: indexPath) as! SimilarCollectionViewCell
        cell.productImage.image = UIImage(named: "trojan")
        cell.titleLabel.text = similarItems[indexPath.item]["title"].string ?? ""
        cell.titleLabel.numberOfLines = 3
        cell.titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        cell.shippingCostLabel.text = "$" + String(similarItems[indexPath.item]["shippingCost"].int ?? -1)
        cell.daysLeftLabel.text = String(similarItems[indexPath.item]["leftDay"].int ?? -1) + " Days Left"
        cell.priceLabel.text = "$" + String(similarItems[indexPath.item]["price"].int ?? -1)
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        return cell
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
