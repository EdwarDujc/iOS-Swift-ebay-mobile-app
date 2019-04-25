//
//  ViewController.swift
//  csci571HW9
//
//  Created by Jincheng Du on 4/15/19.
//  Copyright © 2019 Jincheng Du. All rights reserved.
//

import UIKit
import McPicker
import SwiftSpinner
import Toast_Swift
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    //MARK: outlets
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var keyword: UITextField!
    @IBOutlet weak var category: McTextField!    
    @IBOutlet weak var condNewCheckbox: UIButton!
    @IBOutlet weak var condUsedCheckbox: UIButton!
    @IBOutlet weak var condUnspecCheckbox: UIButton!
    @IBOutlet weak var shipPickupCheckbox: UIButton!
    @IBOutlet weak var shipFreeCheckbox: UIButton!
    @IBOutlet weak var distance: UITextField!
    @IBOutlet weak var userZipcode: UITextField!
    @IBOutlet weak var customLocationSwitch: UISwitch!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var wishListTabelView: UITableView!
    @IBOutlet weak var totalKeyLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    @IBOutlet weak var emptyWishListLabel: UILabel!
    
    
    //MARK: properties
    var condNewChecked = false
    var condUsedChecked = false
    var condUnspecChecked = false
    var shipPickupChecked = false
    var shipFreeChecked = false
    var hereZipcode = "00000"
    var searchResultsJson: JSON?
    
    var cartKeys:[String]!
    var cartItems:[String:NSDictionary]!
    
    let category_option:[[String]] = [["All Categories", "Art", "Baby", "Books", "Clothing, Shoes & Accessories", "Computers/Tablets & Networking", "Health & Beauty", "Music", "Video Games & Consoles"]]
    
    @IBAction func SearchWishControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 :
            searchView.isHidden = false
            wishListTabelView.isHidden = true
            totalKeyLabel.isHidden = true
            totalValueLabel.isHidden = true
            emptyWishListLabel.isHidden = true
            break
        case 1:
            if (cartKeys.count > 0){
                searchView.isHidden = true
                wishListTabelView.isHidden = false
                totalKeyLabel.isHidden = false
                totalValueLabel.isHidden = false
                emptyWishListLabel.isHidden = true
                wishListTabelView.reloadData()
            } else {
                searchView.isHidden = true
                wishListTabelView.isHidden = true
                totalKeyLabel.isHidden = true
                totalValueLabel.isHidden = true
                emptyWishListLabel.isHidden = false
            }
            break
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                // Get the new view controller using segue.destination.
                // Pass the selected object to the new view controller.
                if let vc1 = segue.destination as? SearchResultsTableViewController {
                    vc1.searchResultsJson = self.searchResultsJson
                }
            }
    
    func updateTotalPrice(){
        var totalKeyLabelString = "WishList Total(" + String(cartKeys.count)
        if (cartKeys.count <= 1){
            totalKeyLabelString += " item):"
        } else {
            totalKeyLabelString += " items):"
        }
        totalKeyLabel.text = totalKeyLabelString
        
        var totalPrice = 0.0
        if (cartKeys.count) > 0 {
            for index in 0...cartKeys.count-1{
                totalPrice += Double(cartItems[cartKeys[index]]!["price"] as! String)!
//                print(cartItems[cartKeys[index]]!["price"])
            }
            totalValueLabel.text = "$" + String(totalPrice)
        }
    }
    
    override func viewDidLoad() {
        
        searchView.isHidden = false
        wishListTabelView.isHidden = true
        totalKeyLabel.isHidden = true
        totalValueLabel.isHidden = true
        emptyWishListLabel.isHidden = true
        
        // MARK: wishList table in viewDidLoad
        self.wishListTabelView.delegate = self
        self.wishListTabelView.dataSource = self
        
        let defaults = UserDefaults.standard
        if let allObject = defaults.dictionary(forKey: "wishList"){
            cartItems=(allObject as? [String:NSDictionary])!
            cartKeys=Array(cartItems.keys)
        }else{
            let store=[String:NSDictionary]()
            defaults.set(store, forKey: "wishList")
            cartItems=store
            cartKeys=[]
        }
        
        updateTotalPrice()
        
        // TEST ONLY! REMOVE!
        self.keyword.text = "iphone"
        
        // Category
        let mcInputView = McPicker(data: category_option)
        category.text="All Categories"
        category.inputViewMcPicker = mcInputView
        category.doneHandler = { [weak category] (selections) in
            category?.text = selections[0]!
        }
        category.cancelHandler = { [weak category] in
        }
        // Location
        customLocationSwitch.isOn = false
        userZipcode.isHidden = true
        distance.placeholder = "10"
        
        Alamofire.request(URLRequest(url: URL(string:"http://ip-api.com/json")! )).responseSwiftyJSON{
            response in
            if let result = response.result.value {
                self.hereZipcode = String(describing: result["zip"])
            }
        }
        
        // Buttons
        searchButton.layer.cornerRadius = 5
        clearButton.layer.cornerRadius = 5
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: Actions, checkbox
    @IBAction func condNewCheckAction(_ sender: Any) {
        if (!condNewChecked){
            condNewCheckbox.setImage(UIImage(named: "checked") , for: UIControl.State.normal)
            condNewChecked = true
        }
        else {
            condNewCheckbox.setImage(UIImage(named: "unchecked") , for: UIControl.State.normal)
            condNewChecked = false
        }
    }
    @IBAction func condUsedCheckAction(_ sender: Any) {
        if (!condUsedChecked){
            condUsedCheckbox.setImage(UIImage(named: "checked") , for: UIControl.State.normal)
            condUsedChecked = true
        }
        else {
            condUsedCheckbox.setImage(UIImage(named: "unchecked") , for: UIControl.State.normal)
            condUsedChecked = false
        }
    }
    @IBAction func condUnspecCheckAction(_ sender: Any) {
        if (!condUnspecChecked){
            condUnspecCheckbox.setImage(UIImage(named: "checked") , for: UIControl.State.normal)
            condUnspecChecked = true
        }
        else {
            condUnspecCheckbox.setImage(UIImage(named: "unchecked") , for: UIControl.State.normal)
            condUnspecChecked = false
        }
    }
    @IBAction func shipPickupCheckAction(_ sender: Any) {
        if (!shipPickupChecked){
            shipPickupCheckbox.setImage(UIImage(named: "checked") , for: UIControl.State.normal)
            shipPickupChecked = true
        }
        else {
            shipPickupCheckbox.setImage(UIImage(named: "unchecked") , for: UIControl.State.normal)
            shipPickupChecked = false
        }
    }
    @IBAction func shipFreeCheckAction(_ sender: Any) {
        if (!shipFreeChecked){
            shipFreeCheckbox.setImage(UIImage(named: "checked") , for: UIControl.State.normal)
            shipFreeChecked = true
        }
        else {
            shipFreeCheckbox.setImage(UIImage(named: "unchecked") , for: UIControl.State.normal)
            shipFreeChecked = false
        }
    }
    @IBAction func customLocationSwitchAction(_ sender: UISwitch) {
        if(sender.isOn){
            userZipcode.isHidden = false
        }
        else {
            userZipcode.isHidden = true
        }
    }
    
    // MARK: Actions, buttons
    func DisplayMessage(m:String){
        self.view.makeToast(m, duration: 1.5, position: .bottom)
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        keyword.text=keyword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if(keyword.text==""){
            DisplayMessage(m: "Keyword Is Mandatory")
            return ;
        }
        if(customLocationSwitch.isOn){
            userZipcode.text=userZipcode.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if(userZipcode.text==""){
                DisplayMessage(m: "Zipcode Is Mandatory")
                return ;
            }
        }
        var url = "http://csci571-jincheng-nodejs.us-east-2.elasticbeanstalk.com/search?"
        // keyword
        url = url + "keyword=";
        url = url + (keyword.text!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))!
        // category
        url = url + "&category="
        switch category.text {
        case "All Categories":
            url += "all_categories"
        case "Art":
            url += "art"
        case "Baby":
            url += "baby"
        case "Books":
            url += "books"
        case "Clothing, Shoes & Accessories":
            url += "clothing_shoes_accessories"
        case "Computers/Tablets & Networking":
            url += "computers_tablets_networking"
        case "Health & Beauty":
            url += "health_beauty"
        case "Music":
            url += "music"
        case "Video Games & Consoles":
            url += "video_games_consoles"
        default:
            url += ""
        }
        // condition
        url += "&condition_new="
        if(condNewChecked){
            url += "true"
        } else {
            url += "false"
        }
        url += "&condition_used="
        if(condUsedChecked){
            url += "true"
        } else {
            url += "false"
        }
        url += "&condition_unspecified="
        if(condUnspecChecked){
            url += "true"
        } else {
            url += "false"
        }
        // shipping
        url += "&shipping_local="
        if(shipPickupChecked){
            url += "true"
        } else {
            url += "false"
        }
        url += "&shipping_free="
        if(shipFreeChecked){
            url += "true"
        } else {
            url += "false"
        }
        // distance
        url += "&distance="
        url = url + (distance.text=="" ? "10" : (distance.text!) )
        // zipcode
        url += "&zipcodeCustom="
        if(customLocationSwitch.isOn){
            url += "true"
        } else {
            url += "false"
        }
        url += "&hereZipcode="
        url += hereZipcode
        url += "&userZipcode="
        url += userZipcode.text!
        
//        print(url)
        SwiftSpinner.show("Searching...")
        Alamofire.request(URLRequest(url: URL(string: url)! )).responseSwiftyJSON{
            response in
            SwiftSpinner.hide()
            if let result = response.result.value {
                self.searchResultsJson = result
//                print("searchResultsJson in ViewController: ", self.searchResultsJson)
                self.performSegue(withIdentifier: "mainToResults", sender: nil)
            }
        }
    }
        
    @IBAction func clearButtonAction(_ sender: Any) {
        keyword.text = ""
        category.text = "All Categories"
        condNewChecked = false
        condNewCheckbox.setImage(UIImage(named: "unchecked") , for: UIControl.State.normal)
        condUsedChecked = false
        condUsedCheckbox.setImage(UIImage(named: "unchecked") , for: UIControl.State.normal)
        condUnspecChecked = false
        condUnspecCheckbox.setImage(UIImage(named: "unchecked") , for: UIControl.State.normal)
        shipPickupChecked = false
        shipPickupCheckbox.setImage(UIImage(named: "unchecked") , for: UIControl.State.normal)
        shipFreeChecked = false
        shipFreeCheckbox.setImage(UIImage(named: "unchecked") , for: UIControl.State.normal)
        distance.placeholder = "10"
        distance.text = ""
        customLocationSwitch.isOn = false
        userZipcode.text = ""
        userZipcode.isHidden = true
    }
    
    // MARK: wish list table
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let row = indexPath.row
        print("go to detail at row ", row)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("cartKeys.count: ", cartKeys.count)
        return cartKeys.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 110.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = wishListTabelView.dequeueReusableCell(withIdentifier: "wishListCell", for: indexPath)
        // Configure the cell...
        if let cartTableViewCell = cell as? WishListTableViewCell {
//            print("indexPath.row: ", indexPath.row)
//            print("cartKeys[indexPath.row]", cartKeys[indexPath.row])
//            print("cartItems[cartKeys[indexPath.row]]: ", cartItems[cartKeys[indexPath.row]])
            let temp = cartItems[cartKeys[indexPath.row]]
//            print("temp:", temp)
            
            cartTableViewCell.titleLabel.text = temp?["title"] as! String
            let priceString = temp?["price"] as! String ?? "Unknown Price"
            cartTableViewCell.priceLabel.text = "$" + priceString
            cartTableViewCell.shippingLabel.text = temp?["shipping"] as! String
            cartTableViewCell.zipcodeLabel.text = temp?["zipcode"] as! String
            cartTableViewCell.conditionLabel.text = temp?["condition"] as! String
            
            let imageUrlString = temp?["viewUrl"] as! String
//            print("imageUrlString", imageUrlString)
            let imageUrl = URL(string: imageUrlString)!
            let imageData = try! Data(contentsOf: imageUrl)
            cartTableViewCell.photoImageView?.image = UIImage(data: imageData) ?? UIImage(named: "defaultImage")
//            cartTableViewCell.photoImageView?.frame = CGRect(x: 20, y:9, width:90, height:90);
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let defaults = UserDefaults.standard
//            var temp=(cartItems[cartKeys[indexPath.row]]!).mutableCopy() as! Dictionary<String,String>;
            let temp = cartItems[cartKeys[indexPath.row]]
            
            let removedTitle = temp!["title"] as! String
            
            cartItems.removeValue(forKey: cartKeys[indexPath.row])
            cartKeys.remove(at: indexPath.row)
            defaults.set(cartItems, forKey: "wishList")
            
            message(m: removedTitle + " was removed from favorites")
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateTotalPrice()
            if(cartKeys.count == 0){
                emptyWishListLabel.isHidden = false
                wishListTabelView.isHidden = true
                totalValueLabel.isHidden = true
                totalKeyLabel.isHidden = true
            }
            
        }
    }
    
    func message(m:String){
        self.view.makeToast(m, duration: 1.5, position: .bottom)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        if let allObject = defaults.dictionary(forKey: "wishList"){
            cartItems=(allObject as? [String:NSDictionary])!
            cartKeys=Array(cartItems.keys)
        }else{
            let store=[String:NSDictionary]()
            defaults.set(store, forKey: "wishList")
            cartItems=store
            cartKeys=[]
            
        }
        wishListTabelView.reloadData()
        updateTotalPrice()
    }
    
}

