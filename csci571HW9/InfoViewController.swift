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

class InfoViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var descriptionTableView: UITableView!
    
    var productSearch: Item!
    var images: [String] = []
    var detailsJson: JSON!
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var sampleDescription = ["k1", "k2", "k3"]
    var Description : [(Name: String, Value: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        name.numberOfLines = 3
        name.lineBreakMode = NSLineBreakMode.byTruncatingTail
        name.text = productSearch.title
        price.text = productSearch.price
        
        // photos
        let url = "http://csci571-jincheng-nodejs.us-east-2.elasticbeanstalk.com/details?itemId=" + productSearch.id
//                print(url)
        SwiftSpinner.show("Fetching Product Details...")
        Alamofire.request(URLRequest(url: URL(string: url)! )).responseSwiftyJSON{
            response in
            SwiftSpinner.hide()
            if let result = response.result.value {
                self.detailsJson = result
                
                DispatchQueue.main.async {
                    self.descriptionTableView.reloadData()
                }
                // description table
                for index in 0...self.detailsJson["Item"]["ItemSpecifics"]["NameValueList"].count - 1 {
                    let pair = self.detailsJson["Item"]["ItemSpecifics"]["NameValueList"][index]
                    let name = pair["Name"].string ?? "N.A."
                    let value = pair["Value"][0].string ?? "N.A."
                    self.Description += [(Name: name, Value: value)]
                }
                
                // photo scroll
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
        
    }
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }

    
    // MARK: description table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sampleDescription.count
        return Description.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = descriptionTableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath)
        
//        let line = sampleDescription[indexPath.row]
//        cell.textLabel?.text = line
//        cell.detailTextLabel?.text = line+"233"
        
        let line = Description[indexPath.row]
        let (key, value) = line
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = value
        
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
