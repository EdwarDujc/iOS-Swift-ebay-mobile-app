//
//  PhotoViewController.swift
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

class PhotoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var itemTitle:String!
    var images: [String] = []
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        itemTitle = itemTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let url = "http://csci571-jincheng-nodejs.us-east-2.elasticbeanstalk.com/photos?keyword=" + (itemTitle.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
        
//        print(url)
        SwiftSpinner.show("Fetching Google Images...")
        Alamofire.request(URLRequest(url: URL(string: url)! )).responseSwiftyJSON{
            response in
            SwiftSpinner.hide()
            if let result = response.result.value {
                for index in 0...result["items"].count - 1 {
                    let picUrl = result["items"][index]["link"].string ?? ""
                    self.images.append(picUrl)
                }
                
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
        
        for index in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
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
