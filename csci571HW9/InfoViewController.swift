//
//  InfoViewController.swift
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

class InfoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    
    var productSearch: Item!
    var images: [String] = []
    var detailsJson: JSON!
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        name.numberOfLines = 3
        name.lineBreakMode = NSLineBreakMode.byTruncatingTail
        name.text = productSearch.title
        price.text = productSearch.price
        
        let url = "http://csci571-jincheng-nodejs.us-east-2.elasticbeanstalk.com/details?itemId=" + productSearch.id
        print(url)

        SwiftSpinner.show("Fetching Product Details...")
        Alamofire.request(URLRequest(url: URL(string: url)! )).responseSwiftyJSON{
            response in
            SwiftSpinner.hide()
            if let result = response.result.value {
                self.detailsJson = result
                for index in 0...result["Item"]["PictureURL"].count - 1 {
                    let picUrl = result["Item"]["PictureURL"][index].string ?? ""
                    self.images.append(picUrl)
                }

                self.pageControl.numberOfPages = self.images.count
                for index in 0..<self.images.count {
                    self.frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
                    self.frame.size = self.scrollView.frame.size

                    let imgView = UIImageView(frame: self.frame)
                    //            imgView.image = UIImage(named: images[index])
                    let imageUrl = URL(string: self.images[index])!
                    let imageData = try! Data(contentsOf: imageUrl)
                    let photo = UIImage(data: imageData) ?? UIImage(named: "defaultImage")

                    imgView.image = photo
                    self.scrollView.addSubview(imgView)
                }
                self.scrollView.contentSize = CGSize(width: (self.scrollView.frame.size.width * CGFloat(self.images.count)), height: self.scrollView.frame.size.height)
                self.scrollView.delegate = self
                
            }
        }
        
//        photos
        pageControl.numberOfPages = images.count
        for index in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size

            let imgView = UIImageView(frame: frame)
            //            imgView.image = UIImage(named: images[index])
            let imageUrl = URL(string: images[index])!
            let imageData = try! Data(contentsOf: imageUrl)
            let photo = UIImage(data: imageData) ?? UIImage(named: "defaultImage")

            imgView.image = photo
            self.scrollView.addSubview(imgView)
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
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
