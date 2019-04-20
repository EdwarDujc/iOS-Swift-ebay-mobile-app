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

class ViewController: UIViewController, UITextFieldDelegate {
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
    
    //MARK: properties
    var condNewChecked = false
    var condUsedChecked = false
    var condUnspecChecked = false
    var shipPickupChecked = false
    var shipFreeChecked = false
    var hereZipcode = "00000"
    var searchResultsJson: JSON?
    
    let category_option:[[String]] = [["All Categories", "Art", "Baby", "Books", "Clothing, Shoes & Accessories", "Computers/Tablets & Networking", "Health & Beauty", "Music", "Video Games & Consoles"]]
    
    @IBAction func SearchWishControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 :
            searchView.isHidden = false
            break
        case 1:
            searchView.isHidden = true
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
    
    override func viewDidLoad() {
        
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
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
}

