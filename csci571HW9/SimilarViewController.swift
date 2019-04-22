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
    
    var images = [UIImage(named: "trojan"), UIImage(named: "trojan"), UIImage(named: "trojan"), UIImage(named: "trojan"), UIImage(named: "trojan")]
    var titles = ["New Authentic Prada Sunglasses PR 13RS TWC/0A7 RED HAVANA", "title2", "title3", "New Authentic Prada Sunglasses PR 13RS TWC/0A7 RED HAVANA yoyoyo", "title5"]
    var shippingCosts = ["$11", "$12", "$13", "$14", "$15"]
    var leftDays = ["1 Days Left", "2 Days Left", "3 Days Left", "4 Days Left", "5 Days Left"]
    var prices = ["$100", "$200", "$300", "$400", "$500"]
    
    func collectionView(_ collectionView:  UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "similarCell", for: indexPath) as! SimilarCollectionViewCell
        cell.productImage.image = images[indexPath.item]
        cell.titleLabel.text = titles[indexPath.item]
        cell.titleLabel.numberOfLines = 3
        cell.titleLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        cell.shippingCostLabel.text = shippingCosts[indexPath.item]
        cell.daysLeftLabel.text = leftDays[indexPath.item]
        cell.priceLabel.text = prices[indexPath.item]
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        return cell
    }
    

    @IBOutlet weak var sortKeySegControl: UISegmentedControl!
    @IBOutlet weak var sortOrderSegControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
//        var layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//        layout.minimumInteritemSpacing = 5
//        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: self.collectionView.frame.size.height/1.5)
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
