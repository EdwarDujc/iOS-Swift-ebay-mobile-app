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
        itemTitle = (itemTitle.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
        itemTitle = itemTitle.replacingOccurrences(of: "&", with: "%26")
        let url = "http://csci571-jincheng-nodejs.us-east-2.elasticbeanstalk.com/photos?keyword=" + itemTitle
//        print("google url: ", url)
        SwiftSpinner.show("Fetching Google Images...")
        Alamofire.request(URLRequest(url: URL(string: url)! )).responseSwiftyJSON{
            response in
            SwiftSpinner.hide()
            if let result = response.result.value {
                for index in 0..<result["items"].count{
                    let picUrl = result["items"][index]["link"].string ?? ""
                    self.images.append(picUrl)
                }
                
                for index in 0..<self.images.count {
                    self.frame.origin.y = self.scrollView.frame.size.height * CGFloat(index)
                    self.frame.size = self.scrollView.frame.size
                    
                    let imgView = UIImageView(frame: self.frame)
                    
                    let imageUrl = URL(string: self.images[index])!
                    let defaultUrl = URL(string: "http://placehold.it/120x120&text=image1")!
                    let defaultImgData = try! Data(contentsOf: defaultUrl)
                    let imageData = try? Data(contentsOf: imageUrl)
                    let photo = UIImage(data: imageData ?? defaultImgData) ?? UIImage(named: "defaultImage")
                    
                    imgView.image = photo
                    self.scrollView.addSubview(imgView)
                }
                
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width , height: (self.scrollView.frame.size.height * CGFloat(self.images.count)))

                
                self.scrollView.delegate = self
            }
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
